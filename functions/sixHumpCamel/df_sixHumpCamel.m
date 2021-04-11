function v = df_sixHumpCamel(X)
    x = X(1);
    y = X(2);
    
    v = X;
    v(1) = (x^2)*((4*x^3)/3 - 4.2*x) + 2*x*((x^4)/3 + 4 - 2.1*x^2) + y;
    v(2) = x + 8*y^3 + 8*y*(y^2-1);
end

