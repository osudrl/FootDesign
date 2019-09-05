%% Establish System Parameters
clear; clc; clf; close all;
warning('off', 'MATLAB:fplot:NotVectorized')    %Remove a common warning that pops up

param.g = 9.8;
param.L_leg = .7;
param.k_leg = 2000;
param.m_leg = 30;
param.c_leg = 0;

param.L_foot = .25;
param.m_foot = 1;
param.c_foot = 0;
param.k_foot = 4000;

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
    [t,x,liftofft,xe,~] = ode45(springmassODE,[max(touchdownt) 10],[xe(end,1) xe(end,2) xe(end,3) xe(end,4)],optionground);
    dynamics = [dynamics; t, x(:,1), x(:,2), x(:,3), x(:,4)];
%     groundforce = [groundforce; t, (param.k_function_handle(-x(:,3)+param.L_foot)).*(-x(:,3)+param.L_foot)];
    groundforce = [groundforce; t, param.k_foot.*(-x(:,3)+param.L_foot)];
    [t,x,touchdownt,xe,~] = ode45(airODE,[max(liftofft) 10],[xe(end,1) xe(end,2) xe(end,3) xe(end,4)],optionair);
    dynamics = [dynamics; t, x(:,1), x(:,2), x(:,3), x(:,4)];
    groundforce = [groundforce; t, zeros(size(t))];
end

%% Back Calculate the Spring Constant and Foot Compressions Used
sz = size(dynamics);
for i = 1:sz(1)
%     dynamics(i,6) = springstiff(0,dynamics(i,2:5),param);   %Use springstiff function to store K values used
    dynamics(i,6) = param.k_foot;   %Use springstiff function to store K values used
    dynamics(i,7) = param.L_foot - dynamics(i,4);           %Calculate Foot Compression
end
dynamics(dynamics(:,7) < 0, 7) = 0;                                     %Correct for Air Phase: zero compression in air
dynamics(dynamics(:,4) > param.L_foot, 6) = param.k_foot; %Correct for Air Phase: K = K(zero compression)
% dynamics(dynamics(:,4) > param.L_foot, 6) = param.k_function_handle(0); %Correct for Air Phase: K = K(zero compression)

%% Animate Hopper
animateHopper(dynamics,groundforce);  %Comment out if you do not want the video

%% Show Impact Data (Un-comment if you want to show data plots)
% E = energy(dynamics, param);
% figure
% plot(groundforce(:,1),E(:,1))
% hold on
% plot(groundforce(:,1),E(:,2))
% plot(groundforce(:,1),E(:,3))
% figure
% F = E(:,1)+E(:,2)+E(:,3);
% plot(groundforce(:,1),F)