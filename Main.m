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
trs1 = TrustRegConicSearch(him, 0.1, options);
trs1.optimization(x0);

options.plotColor = 'k';
trs5 = TrustRegConicSearch(him, 0.5, options);
trs5.optimization(x0);

options.plotColor = 'm';
trs10 = TrustRegConicSearch(him, 0.55, options);
trs10.optimization(x0);

options.plotColor = 'b';
trs1 = TrustRegSearch(him, options);
trs1.optimization(x0);

options.plotColor = 'g';
trs2 = FastGradient(him, @goldensectionsearch, options);
trs2.optimization(x0);

options.plotColor = 'c';
pr = PolakRibiere(him, @goldensectionsearch, options);
pr.optimization(x0);

options.plotColor = 'y';
lfbgs = LBFGS(him, options);
lfbgs.optimization(x0);

trajectoryPlot.drawLegend();
convergancePlot.drawLegend(); 