function [ p ] = create_foot_spring(p)
%CREATE_FOOT_SPRING This is a function that creates function handle (fh)
%objects in the p object for the foot force and foot stiffness using the 
%foot parameters in the p object.
  p.spring_fh = @(d) p.k_foot*d;    % This is the generic force function
  p.k_fh = @(d) p.k_foot;           % The first derivative of the foot force function wrt d

end

