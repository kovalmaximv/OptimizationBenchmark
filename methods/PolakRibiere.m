classdef PolakRibiere < AbstractMethod
    
    properties
        interval,
        p0,
        g0,
        onedimsearch,
        breakOprimization;
    end
    
    methods
        function self = PolakRibiere(func, onedimsearch, options)
            self = self@AbstractMethod(func, options);
            self.onedimsearch = onedimsearch;
            self.interval = [-3; 3];
            self.breakOprimization = false;
        end
        
        function self = optimizationInit(self)
            self.g0 = self.objectiveFunc.df(self.x0);
            self.p0 = -self.g0;
        end
        
        function outputArg = optimizationLoopCondition(self)
            outputArg = (not(self.breakOprimization) && ...
                         (norm(self.g0) >= self.tol) && ...
                         (self.iteration < self.iterationMax) ...
                        );
        end
        
        function self = optimizationStep(self)
            self.fValue = self.objectiveFunc.f(self.x0); % поправить чтобы не считалось eval
            
            self.coordinates(self.iteration, :) = self.x0;
            self.functionValues(self.iteration) = self.fValue;
            self.functionNevals(self.iteration) = self.objectiveFunc.evaluationCount;
            
            f1dim = @(al)(self.objectiveFunc.f(self.x0 + al*self.p0));
            [al,~,~] = goldensectionsearch(f1dim, self.interval, self.tol);
            
            x1 = self.x0 + al*self.p0;
            g = self.objectiveFunc.df(x1);
            b=(g'*(g-self.g0))/(self.g0'*self.g0); %Polak-Ribiere coefficient
            
            if b<0
                b=0;
            end
            
            self.breakOprimization = norm(x1-self.x0) < self.tol;
            
            p = -g + b*self.p0;
            self.x0 = x1;
            self.g0 = g;
            self.p0 = p;
            
            self.iteration = self.iteration + 1;
        end
        
        function [coordinates, functionValues, functionNevals] = optimizationResult(self)
            coordinates = self.coordinates;
            functionValues = self.functionValues;
            functionNevals = self.functionNevals;
        end
        
        function drawPlots(self)
            options.description = strcat('PolakRibier,', num2str(self.iteration - 1), ' iterations');
            options.color = self.plotColor;
            deltas = zeros(1, length(self.coordinates));
            self.trajectoryPlot.initiate(self.objectiveFunc, options);
            self.trajectoryPlot.draw(self.coordinates, deltas);

            self.convergancePlot.initiate(options);
            self.convergancePlot.draw(self.objectiveFunc.realMin, self.functionNevals, self.functionValues);
        end
    end
end

