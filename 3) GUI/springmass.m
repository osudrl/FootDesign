function [dxdt] = springmass(t,x,p)

% kfoot=springstiff(t,x,p);   %Find Current Foot Stiffness (K)
kfoot=p.k_foot;   %Find Current Foot Stiffness (K)

dxdt = [x(2); ...
    -p.g-(p.k_leg)/p.m_leg*(x(1)-p.L_leg-x(3))-(p.c_leg*(x(2)-x(4))/p.m_leg);...
    x(4);...
    -p.g-(kfoot)/p.m_foot*(x(3)-p.L_foot)+(p.k_leg)/p.m_foot*(x(1)-p.L_leg-x(3))-((p.c_foot*x(2))/p.m_foot)+((p.c_leg*(x(2)-x(4)))/p.m_foot)];
end