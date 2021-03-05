him = AbstractFunction(@f_himmelblau, @df_himmelblau, @hes_himmelblau);

options.funcCLass = him;
options.iterationMax = 10000;
options.tol = 1e-3;
options.shouldDrawPlots = true;

trs = TrustRegSearch(options);

x0 = [1;3];
[coordinates, funValues, funNevals] = trs.optimization(x0);