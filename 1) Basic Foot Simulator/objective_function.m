function cost = objective_function(x,p)
    p.k_foot = x;                       % Current x of fmincon is saved as the system's K value
    p = create_foot_spring(p);          % Create Foot Spring Function
    [v_foot, trigger_time, BO_comp] =...
        data_at_zero_acl(p);            % Returns data correlating to when FOOT ACCELERATION EQUALS ZERO
    cost = (v_foot)^2;              % Cost function that fmincon tries to get to zero
end