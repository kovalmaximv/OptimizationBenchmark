him = AbstractFunction(@f_himmelblau, @df_himmelblau, @hes_himmelblau);
plotSleepTime = 0.1;
trajectoryPlot = TrustRegionDeltaPlot(plotSleepTime, 0.8);
convergancePlot = ConvergancePlot(plotSleepTime);

options.iterationMax = 10000;
options.tol = 1e-3;
options.shouldDrawPlots = true;
options.trajectoryPlot = trajectoryPlot;
options.convergancePlot = convergancePlot;
options.plotColor = 'r';

x0 = [1;3];

trs = TrustRegConicSearch(him, options);
[coordinates, funValues, funNevals] = trs.optimization(x0);

options.plotColor = 'b';
trs = TrustRegSearch(him, options);
[coordinates1, funValues1, funNevals1] = trs.optimization(x0);

trajectoryPlot.drawLegend();
convergancePlot.drawLegend(); 