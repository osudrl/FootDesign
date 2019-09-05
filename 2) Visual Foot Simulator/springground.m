function [dxdt] = springground(t,x,p)

dxdt = [x(2); -p.g-(p.k_leg)/p.m_leg*(x(1)-p.L_leg-x(3)); x(4); -p.g-(p.k_ground)/p.m_foot*(x(3)-p.L_foot)+(p.k_leg)/p.m_foot*(x(1)-p.L_leg-x(3))];

end