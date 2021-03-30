classdef FastGradient < AbstractMethod
    
    properties
        interval, % search interval in 1 dimension search
        onedimsearch; % optimization method for 1 dim search
    end
    
    methods
        function self = FastGradient(func, onedimsearch, options)
            % FastGradient Construct an instance of this class
            % call superclass constructor
            self = self@AbstractMethod(func, options);
            self.onedimsearch = onedimsearch;
            self.interval = [-1; 1];
        end
        
        function outputArg = optimizationLoopCondition(self)
            outputArg = ((norm(self.dx) >= self.tol) && (self.iteration < self.iterationMax));
        end
        
        function self = optimizationInit(self)
            
        end
        
        function self = optimizationStep(self)
            % find coefficients for the model
            f0 = self.objectiveFunc.f(self.x0);
            self.fValue = f0;
            
            self.coordinates(self.iteration, :) = self.x0;
            self.functionValues(self.iteration) = self.fValue;
            self.functionNevals(self.iteration) = self.objectiveFunc.evaluationCount;
            
            f1dim = @(al)(self.objectiveFunc.f(self.x0 - al * self.objectiveFunc.df(self.x0)));
            
            %[minalpha,~,~] = self.onedimsearch(f1dim, self.interval, self.tol);
            [minalpha,~,~] = goldensectionsearch(f1dim, self.interval, self.tol);
            
            x1 = self.x0 - minalpha * self.objectiveFunc.df(self.x0);
            self.dx = abs(x1 - self.x0);
            self.x0 = x1;
            
            self.iteration = self.iteration + 1;
        end
        
        function [coordinates, functionValues, functionNevals] = optimizationResult(self)
            coordinates = self.coordinates;
            functionValues = self.functionValues;
            functionNevals = self.functionNevals;
        end
        
        function drawPlots(self)
            options.description = strcat('FastGradient,', num2str(self.iteration - 1), ' iterations');
            options.color = self.plotColor;
            deltas = zeros(1, length(self.coordinates));
            self.trajectoryPlot.initiate(self.objectiveFunc, options);
            self.trajectoryPlot.draw(self.coordinates, deltas);

            self.convergancePlot.initiate(options);
            self.convergancePlot.draw(self.functionNevals, self.functionValues);
        end
    end
end

