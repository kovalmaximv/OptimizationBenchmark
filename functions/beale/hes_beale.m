function v = hes_beale(X)
    x = X(1);
    y = X(2);
    
    term1dxdx = 2*(y-1)^2;
    term1dxdy = 2*(x*y+x*(y-1)-x+1.5);
    term1dydx = 2*(x*y+x*(y-1)-x+1.5);
    term1dydy = 2*x^2;
    
    term2dxdx = 2*(y^2-1)^2;
    term2dxdy = 4*y*(x*y^2+x*(y^2-1)-x+2.25);
    term2dydx = 4*y*(x*y^2+x*(y^2-1)-x+2.25);
    term2dydy = 4*x*(3*x*y^2-x-2.25);
    
    term3dxdx = 2*(y^3-1)^2;
    term3dxdy = 6*y^2*(x*y^3+x*(y^3-1)-x+2.625);
    term3dydx = 6*y^2*(x*y^3+x*(y^3-1)-x+2.625);
    term3dydy = 6*x*y*(5*x*y^3-2*x+5.25);
    
    vxx = term1dxdx + term2dxdx + term3dxdx;
    vxy = term1dxdy + term2dxdy + term3dxdy;
    vyx = term1dydx + term2dydx + term3dydx;
    vyy = term1dydy + term2dydy + term3dydy;
    v = [[vxx, vxy];[vyx, vyy]];
end

