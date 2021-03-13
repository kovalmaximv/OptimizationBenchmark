him = AbstractFunction(@f_himmelblau, @df_himmelblau, @hes_himmelblau);
trajectoryPlot = TrustRegionDeltaPlot(0.1, 0.8);

options.iterationMax = 10000;
options.tol = 1e-3;
options.shouldDrawPlots = true;
options.trajectoryPlot = trajectoryPlot;
options.plotColor = 'r';

x0 = [1;3];

trs = TrustRegConicSearch(him, options);
[coordinates, funValues, funNevals] = trs.optimization(x0);


options.plotColor = 'b';
trs = TrustRegSearch(him, options);
[coordinates1, funValues1, funNevals1] = trs.optimization(x0);

trajectoryPlot.drawLegend();