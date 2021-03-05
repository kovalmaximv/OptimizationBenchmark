him = AbstractFunction(@f_himmelblau, @df_himmelblau, @hes_himmelblau);

options.iterationMax = 10000;
options.tol = 1e-3;
options.shouldDrawPlots = true;

trs = TrustRegConicSearch(him, options);
x0 = [1;3];
[coordinates, funValues, funNevals] = trs.optimization(x0);
disp('Trust region conic search')
disp('last coordinates:')
coordinates(end, :)
disp('last function value:')
funValues(end)
disp('function nevals:')
funNevals(end)

trs = TrustRegSearch(him, options);
x0 = [1;3];
[coordinates, funValues, funNevals] = trs.optimization(x0);
disp('Trust region regular search:')
disp('last coordinates:')
coordinates(end, :)
disp('last function value:')
funValues(end)
disp('function nevals:')
funNevals(end)