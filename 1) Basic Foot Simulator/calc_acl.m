function [s] = DUAL_Dynamics(p,s)
% Calculates the Foot Compression and Foot Acceleration. Puts those into
% the solution (s) matrix and returns solutions.
    sz = size(s);
    for i = 1:sz(1)
        s(i,5) = s(i,3) - p.L_foot;
        s(i,6) = -p.g-(p.k_foot)/p.m_foot*(s(i,3)-p.L_foot)+(p.k_leg)/p.m_foot*(s(i,1)-p.L_leg-s(i,3))-((p.c_foot*s(2))/p.m_foot)+((p.c_leg*(s(i,2)-s(i,4)))/p.m_foot);
    end