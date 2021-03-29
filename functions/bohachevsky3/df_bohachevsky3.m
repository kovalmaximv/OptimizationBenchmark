function v = df_bohachevsky3(X)
% INPUT:
%   xx = [x1, x2]

    x = X(1);
    y = X(2);

    v = X;
    v(1) = 0.9 * pi * sin(3*pi*x + 4*pi*y) + 2*x;
    v(2) = 1.2 * pi * sin(3*pi*x + 4*pi*y) + 4*y;
end

