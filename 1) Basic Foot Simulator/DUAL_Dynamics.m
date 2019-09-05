function [dxdt] = DUAL_Dynamics(t,x,p)
% ODE uses this model of system dynamics during DUAL phase. System is a two
% mass, two spring, system.

current_comp = p.L_foot-x(3);           % Find current foot compression (d)
current_k_foot = p.k_fh(current_comp);  % Find current foot stiffness

% Equations of Motion are:
% [     body velocity    ]
% [   body acceleration  ]
% [    foot velocity     ]
% [   foot acceleration  ]

dxdt = [x(2); ...
    -p.g-(p.k_leg)/p.m_leg*(x(1)-p.L_leg-x(3))-(p.c_leg*(x(2)-x(4))/p.m_leg);...
    x(4);...
    -p.g-(current_k_foot)/p.m_foot*(x(3)-p.L_foot)+(p.k_leg)/p.m_foot*(x(1)-p.L_leg-x(3))-((p.c_foot*x(2))/p.m_foot)+((p.c_leg*(x(2)-x(4)))/p.m_foot)];
end