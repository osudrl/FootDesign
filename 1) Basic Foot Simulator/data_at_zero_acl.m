function [v_foot, trigger_time, BO_comp] = data_at_zero_acl(p)

% Establish ODE Functions and Triggers for Later Use
DUAL_Dynamics_ODE = @(t,x) DUAL_Dynamics(t,x,p);            % ODE Function (dyanmics of hopper in DUAL phase)
end_DUAL_event = @(t,x) end_DUAL(t,x,p);                    % Identify when foot acceleration (acl) is zero
end_DUAL_trigger = odeset('Events', end_DUAL_event);        % End ODE because event (foot acl = 0) triggered

% Do Math
xe = [(p.L_leg + p.L_foot) p.v_init (p.L_foot) p.v_init];   %[X_body, V_body, X_foot, V_foot] at cycle start
[~,~,trigger_time,xe,~] =...
    ode45(DUAL_Dynamics_ODE,[0, p.time_stop],[xe(1) xe(2) xe(3) xe(4)],...
    end_DUAL_trigger);              % Solves the system. Returns times (t), states (x), trigger time, and state at trigger (xe)
BO_comp = p.L_foot - xe(3);         % Compression when foot acl = 0 (Bottoming Out Compression)
v_foot = xe(4);                     % Foot velocity when foot acl = 0
end