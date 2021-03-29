function v = hes_bohachevsky1(X)
    x = X(1);
    y = X(2);
    
    vxx = 2.7*pi^2*cos(3*pi*x) + 2;
    vxy = 0;
    vyx = 0;
    vyy = 6.4*pi^2*cos(4*pi*y) + 4;
    
    v = [[vxx, vxy];[vyx, vyy]];
end

