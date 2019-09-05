function [position,isterminal,direction] = end_DUAL(t,x,p)
% This function is for calculating when to trigger the end of the DUAL
% phase. This trigger happens when foot acceleration equals zero.

% This is foot's acceleration equation, copy/pasted from DUAL_Dynamics
position = -p.g-(p.k_fh(p.L_foot-x(3)))/p.m_foot*(x(3)-p.L_foot)+...
    (p.k_leg)/p.m_foot*(x(1)-p.L_leg-x(3))-...
    ((p.c_foot*x(2))/p.m_foot)+...
    ((p.c_leg*(x(2)-x(4)))/p.m_foot);

isterminal = [1];   % 1 means to halt integration when event triggers
direction = [-1];    % When position equation approaches zero, must approach from decreasing direction (-1)

% Direction value is important! Foot starts with -g acceleration and
% quickly goes from negative to positive accelearation (increasing
% direction, +).  This is not the halt point we want!  We want the next
% one, when acceleration is positive and returns to zero (decreasing
% direction, -). Thus, we must use -1 for direction.
end