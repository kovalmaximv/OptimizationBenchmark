him = AbstractFunction('himmelblau', 0, @f_himmelblau, @df_himmelblau, @hes_himmelblau);
plotSleepTime = 0;
trajectoryPlot = TrustRegionDeltaPlot(plotSleepTime, 0.8);
convergancePlot = ConvergancePlot(plotSleepTime);

options.iterationMax = 10000;
options.tol = 1e-4;
options.shouldDrawPlots = true;
options.trajectoryPlot = trajectoryPlot;
options.convergancePlot = convergancePlot;
options.plotColor = 'r';

x0 = [1;3];

options.alpha = 0.5;
trs = TrustRegConicSearch(him, options);
[coordinates, funValues, funNevals] = trs.optimization(x0);

options.plotColor = 'b';
trs1 = TrustRegSearch(him, options);
[coordinates1, funValues1, funNevals1] = trs1.optimization(x0);

options.plotColor = 'g';
trs2 = FastGradient(him, @goldensectionsearch, options);
[coordinates2, funValues2, funNevals2] = trs2.optimization(x0);

options.plotColor = 'c';
pr = PolakRibiere(him, @goldensectionsearch, options);
[coordinates3, funValues3, funNevals3] = pr.optimization(x0);

options.plotColor = 'y';
lfbgs = LBFGS(him, options);
[coordinates4, funValues4, funNevals4] = lfbgs.optimization(x0);

trajectoryPlot.drawLegend();
convergancePlot.drawLegend(); 