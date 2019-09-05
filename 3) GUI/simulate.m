function [dynamics] = simulate(param, switch_val)

warning('off', 'MATLAB:fplot:NotVectorized')    %Remove a common warning that pops up



%% Establish Functions You Will Use
airODE = @(t,x) air(t,x,param);                             %Hopper in the air
springmassODE= @(t,x) springmass(t,x,param);                %Hopper on the ground
touchesgroundODE= @(t,x) touchesground(t,x,param);          %Identify when Hopper touches the ground
liftoffODE= @(t,x) liftoff(t,x,param);                      %Identify when Hopper leaves the ground
solidgroundODE = @(t,x) solidground(t,x,param);

optionair = odeset('Events', touchesgroundODE);             %Tuchdown
optionground = odeset('Events', liftoffODE);                %Liftoff
xe = [(param.L_leg + param.L_foot) -2 (param.L_foot) -2];   %[Pos_body, Vel_body, Pos_foot, Vel_foot] for a single cycle

%% Establish Blank Values/Matricies You Will Use
dynamics = [];      %[time, xe_1, xe_2, xe_3, xe_4] for ALL cycles
touchdownt=0;
groundforce = [];   %[time, Ground Reaction Force] for ALL cycles

%% Start ODE Loop to Solve the System

for i = 1:1
  
    [t,x,liftofft,xe,~] = ode45(springmassODE,[0 10],[xe(end,1) xe(end,2) xe(end,3) xe(end,4)],optionground);
    dynamics = [t, x(:,1), x(:,2), x(:,3), x(:,4)];
%     groundforce = [groundforce; t, (param.k_function_handle(-x(:,3)+param.L_foot)).*(-x(:,3)+param.L_foot)];
%     groundforce = [groundforce; t, param.k_foot.*(-x(:,3)+param.L_foot)];
    [t,x,touchdownt,xe,~] = ode45(airODE,[max(liftofft) 10],[xe(end,1) xe(end,2) xe(end,3) xe(end,4)],optionair);
    dynamics = [dynamics; t, x(:,1), x(:,2), x(:,3), x(:,4)];
    dynamics(:,4) = dynamics(:,4) - param.L_foot;
%     all_dynamics{i} = dynamics;
%     groundforce = [groundforce; t, zeros(size(t))];
end

if switch_val == 1
    data_points = size(dynamics,1);
    for i = 1:data_points
        if dynamics(i,4) <= -param.hard_stop
            dynamics(i,5) = 0;
            dynamics(i,4) = -param.hard_stop;
        end
    end
end