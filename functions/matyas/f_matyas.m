function v = f_matyas(xx)
% min at x=(0,0). fmin = 0
    x1 = xx(1);
    x2 = xx(2);
    
    v = 0.26*(x1^2 + x2^2) - 0.48*x1*x2;
end

