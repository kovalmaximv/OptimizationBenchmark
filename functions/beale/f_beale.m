function v = f_beale(xx)
% INPUT:
%   xx = [x1, x2]
% Global minimum:
%   x = (3, 0.5)
    x1 = xx(1);
    x2 = xx(2);

    term1 = (1.5 - x1 + x1*x2)^2;
    term2 = (2.25 - x1 + x1*x2^2)^2;
    term3 = (2.625 - x1 + x1*x2^3)^2;

    v = term1 + term2 + term3;
end
