him = AbstractFunction(@f_bohachevsky1, @df_bohachevsky1, @hes_bohachevsky1);
plotSleepTime = 0;
trajectoryPlot = TrustRegionDeltaPlot(plotSleepTime, 0.8);
convergancePlot = ConvergancePlot(plotSleepTime);

options.iterationMax = 10000;
options.tol = 1e-3;
options.shouldDrawPlots = true;
options.trajectoryPlot = trajectoryPlot;
options.convergancePlot = convergancePlot;
options.plotColor = 'r';

x0 = [1;3];

options.alpha = 0.5;
trs = TrustRegConicSearch(him, options);
[coordinates, funValues, funNevals] = trs.optimization(x0);

options.plotColor = 'b';
trs = TrustRegSearch(him, options);
[coordinates1, funValues1, funNevals1] = trs.optimization(x0);

trajectoryPlot.drawLegend();
convergancePlot.drawLegend(); 