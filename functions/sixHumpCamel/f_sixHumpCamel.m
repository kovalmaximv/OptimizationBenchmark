function v = f_sixHumpCamel(xx)
% min at x=(0.0898, -0.7126) and (-0.0898, 0.7126). fmin = -1.0317
    x1 = xx(1);
    x2 = xx(2);
    
    v = (4 - 2.1 * x1^2 + (x1^4)/3) * x1^2 + x1*x2 + (4*x2^2 - 4) * x2^2;
end

