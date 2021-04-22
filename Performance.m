him = AbstractFunction('himmelblau', 0, @f_himmelblau, @df_himmelblau, @hes_himmelblau);
matyas = AbstractFunction('matyas', 0, @f_matyas, @df_matyas, @hes_matyas);
beale = AbstractFunction('beale', 0, @f_beale, @df_beale, @hes_beale);
sixHumpCamel = AbstractFunction('sixHumpCamel', -1.0317, @f_sixHumpCamel, @df_sixHumpCamel, @hes_sixHumpCamel);
bohachevsky1 = AbstractFunction('bohachevsky1', 0, @f_bohachevsky1, @df_bohachevsky1, @hes_bohachevsky1);

functions = [him, matyas, sixHumpCamel, bohachevsky1];

options.iterationMax = 10000;
options.tol = 1e-4;
options.shouldDrawPlots = false;
options.alpha = 0.5;
options.plotColor = 'b';

performance = PerformancePlot(0, 1);
performance.initiate();
for i = 1 : length(functions)
    func = functions(i);
    performance.initiateFunc(func.funcName);
    
    x0 = [1;3];
    
    trcs = TrustRegConicSearch(func, options);
    [~, ~, funNevals] = trcs.optimization(x0);
    performance.keepConvergance(funNevals);
    if i == 1
        performance.initiateMethod('TrustRegConicSearch')
    end
    
    trs = TrustRegSearch(func, options);
    [~, ~, funNevals] = trs.optimization(x0);
    performance.keepConvergance(funNevals);
    if i == 1
        performance.initiateMethod('TrustRegSearch')
    end
    
    fgs = FastGradient(func, @goldensectionsearch, options);
    [~, ~, funNevals] = fgs.optimization(x0);
    performance.keepConvergance(funNevals);
    if i == 1
        performance.initiateMethod('FastGradient')
    end
end


performance.calculateRps();
performance.drawPlot();