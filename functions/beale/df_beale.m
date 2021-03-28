function v = df_beale(X)
    x = X(1);
    y = X(2);
    
    term1dx = 2*(1.5-x+x*y)*(y-1);
    term1dy = 2*x*(1.5-x+x*y);
    term2dx = (2*y^2-2)*(x*y^2+2.25-x);
    term2dy = 4*x*y*(x*y^2+2.25-x);
    term3dx = (2*y^3-2)*(x*y^3+2.625-x);
    term3dy = 6*x*y^2*(x*y^3+2.625-x);

    v = X;
    v(1) = term1dx + term2dx + term3dx;
    v(2) = term1dy + term2dy + term3dy;
end

