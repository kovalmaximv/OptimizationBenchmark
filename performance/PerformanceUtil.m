classdef PerformanceUtil
    
    methods(Static)
        function optimizeAndKeepConvergence(iteration, x0, methodName, performance, someMethod)
            [~, ~, funNevals] = someMethod.optimization(x0);
            performance.keepConvergance(funNevals);
            if iteration == 1
                performance.initiateMethod(methodName)
            end
        end
    end
end

