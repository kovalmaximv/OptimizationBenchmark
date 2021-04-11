function v = df_matyas(X)
    x = X(1);
    y = X(2);
    
    v = X;
    v(1) = 0.52 * x - 0.48 * y;
    v(2) = -0.48 * x + 0.52 * y;
end

