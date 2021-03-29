function v = hes_bohachevsky3(X)
    x = X(1);
    y = X(2);
    
    vxx = 2.7*pi^2*cos(3*pi*x+4*pi*y)+2;
    vxy = 3.6*pi^2*cos(3*pi*x+4*pi*y);
    vyx = 3.6*pi^2*cos(3*pi*x+4*pi*y);
    vyy = 4.8*pi^2*cos(3*pi*x+4*pi*y)+4;
    
    v = [[vxx, vxy];[vyx, vyy]];
end

