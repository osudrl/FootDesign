function [k] = springstiff(t,x,p)

k = p.k_function_handle(p.L_foot-x(3));

end