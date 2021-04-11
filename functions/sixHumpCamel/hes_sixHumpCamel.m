function v = hes_sixHumpCamel(X)
    x = X(1);
    y = X(2);
    
    vxx = 2*x^4/3 + 4*x^2*(20*x^2-63)/15 + x^2*(20*x^2-21)/5 - 21*x^2/5 + 8;
    vxy = 0;
    vyx = 1;
    vyy = 48*y^2 - 8;
    
    v = [[vxx, vxy];[vyx, vyy]];
end

