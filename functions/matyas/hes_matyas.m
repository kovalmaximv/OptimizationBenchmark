function v = hes_matyas(X)
    x = X(1);
    y = X(2);
    
    vxx = 0.52;
    vxy = -0.48;
    vyx = -0.48;
    vyy = 0.52;
    
    v = [[vxx, vxy];[vyx, vyy]];
end

