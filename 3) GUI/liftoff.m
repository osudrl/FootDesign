function [position,isterminal,direction] = liftoff(t,x,p)

position = x(3)-p.L_foot;   % The value that we want to be zero
isterminal = 1;             % Halt integration 
direction = 1;              % The zero can be approached from negtive direction

end