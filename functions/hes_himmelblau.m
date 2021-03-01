function v = hes_himmelblau(X)

x = X(1);
y = X(2);

v = [[ 12*x.^2 + 4*y - 42 , 4*x + 4*y ];[ 4*x + 4*y , 12*y.^2 + 4*x - 26 ]];

end

