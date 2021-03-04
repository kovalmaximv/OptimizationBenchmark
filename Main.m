him = AbstractFunction(@f_himmelblau, @df_himmelblau, @hes_himmelblau);

trs = TrustRegSearch(him, 10000, 1e-3);

x0 = [1;3];
[coordinates, funValues, funNevals] = trs.optimization(x0);

TraectoryPlot.initiate(him);
TraectoryPlot.draw(coordinates);