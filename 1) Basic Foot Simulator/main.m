clear; clc; clf; close all;
warning('off', 'MATLAB:fplot:NotVectorized')    % Remove a common warning that pops up

%% Parameters (p)
p.v_init = -2;      % Velocity of the system (m/s)
p.time_stop = .3;    % ODE45 stops after this time if fmincon search fails (sec)
p.time_div = .001;  % Time Increments for ODE45
p.g = 9.8;          % Gravity Constant (m/s^2)
p.L_leg = .8;       % Length of the leg (m)
p.k_leg = 1667;    % Spring constant of the leg
p.m_leg = 9.6875;   % Point Mass of the leg/robot (kg) 
p.c_leg = 106;      % Damping of the leg spring
p.L_foot = .07;     % Length (aka: height) of the foot (m)
p.m_foot = 0.88;       % Mass of the foot (kg)
p.c_foot = 70;       % Damping of the foot spring

%% K Ranges to Search for in Equation y = K(d)
K_lower = 1;                    % Lower K search value
K_upper = 100000;                 % Upper K serach value
x0 = mean([K_lower,K_upper]);   % Value that fmincon starts searching at

%% Find Optimum K Value
options = optimoptions('fmincon','Display','final','Algorithm','interior-point','OptimalityTolerance',1e-10);
k_optimum = fmincon(@(x)objective_function(x,p),x0,[],[],[],[],K_lower,K_upper,[],options);
k_optimum_round = round(k_optimum);

%% With Optimum K Value, Now Solve For Other Data
p.k_foot = k_optimum;                                   % Save k_optimum into the system
p = create_foot_spring(p);                              % Create the foot spring function handles
[v_foot, trigger_time, BO_comp] = data_at_zero_acl(p);  % Returns data correlating to when FOOT ACCELERATION EQUALS ZERO
cost = (v_foot)^2;                                      % Cost Function that fmincon Used

%% Solve System with ODE. ODE Returns Times and States.
DUAL_Dynamics_ODE = @(t,x) DUAL_Dynamics(t,x,p);            % ODE Function (dyanmics of hopper in DUAL phase)
xe = [(p.L_leg + p.L_foot) p.v_init (p.L_foot) p.v_init];   % [X_body, V_body, X_foot, V_foot] at cycle start
[time,states] = ode45(DUAL_Dynamics_ODE, [0, p.time_stop], xe);
[states] = calc_acl(p,states);                              % Returns [X_body, V_body, X_foot, V_foot, Foot_Compression, ACL_foot]

%% Find Peaks
[peaks, peaks_index] = findpeaks(states(:,4));  % Find All Velocity Peaks
peak_index = peaks_index(1);                    % We only care about the first velocity peak

%% Display Solutions Found from Searches
fprintf('Linear Foot Stiffness: %d N/m\n',k_optimum_round);
fprintf('Foot Bottom Out Compression: %d mm\n',round(BO_comp*1000));

%% Display System Response
figure('units','normalized','outerposition',[0 0 1 1])      % Auto Full Screen

subplot(3,1,1);
hold on
plot(time, states(:,5));
y_axis = ylim;
line([time(peak_index) time(peak_index)],...
    [y_axis(1) y_axis(2)],...
    'color', 'g', 'linestyle', '--');
fplot((@(x) -BO_comp), [0 time(peak_index)], 'g--')
fplot((@(x) 0), [0 p.time_stop], 'k:')
xlabel 'Time (sec)';
ylabel 'Distance from Starting Point (m)'
title 'Foot Position (AKA: Compression)'
str = {strcat('Foot Dynamics when K = ', num2str(k_optimum_round))};
legend (str)

subplot(3,1,2);
hold on
plot(time, states(:,4));
y_axis = ylim;
line([time(peak_index) time(peak_index)],...
    [y_axis(1) y_axis(2)],...
    'color', 'g', 'linestyle', '--');
fplot((@(x) 0), [0 p.time_stop], 'k:')
xlabel 'Time (sec)';
ylabel 'Foot Velocity (m/sec)'
title 'Foot Velocity'

subplot(3,1,3);
hold on
plot(time, states(:,6));
y_axis = ylim;
line([time(peak_index) time(peak_index)],...
    [y_axis(1) y_axis(2)],...
    'color', 'g', 'linestyle', '--');
fplot((@(x) 0), [0 p.time_stop], 'k:')
xlabel 'Time (sec)';
ylabel 'Foot Acceleration (m/sec^2)'
title 'Foot Acceleration'
