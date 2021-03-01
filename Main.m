him = AbstractFunction(@f_himmelblau, @df_himmelblau, @hes_himmelblau);

trs = TrustRegConicSearch(him, 10000, 1e-3);

x0 = [1;3];
trs.optimization(x0)