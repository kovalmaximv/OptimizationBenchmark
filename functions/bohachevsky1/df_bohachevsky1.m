function v = df_bohachevsky1(X)
% INPUT:
%   xx = [x1, x2]

    x = X(1);
    y = X(2);

    v = X;
    v(1) = 2*x + 0.9*pi*sin(3*pi*x);
    v(2) = 4*y + 1.6*pi*sin(4*pi*y);
end

