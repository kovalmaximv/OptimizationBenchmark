classdef AbstractMethod < handle
    % ABSTRACTMETHOD Abstract class that all real methods must extend 
    
    properties
        objectiveFunc, % AbstractFunction object. Contains objective func and der func
        iteration, % current iteration
        iterationMax, % max iteration num when alg must stop
        dx, % X difference between two steps
        tol, % tolerance that used in stop criteria with dx
        x0, % current coordinates
        fValue, % current func value
        coordinates, % history of coordinates
        functionValues, % history of function values
        functionNevals, % history of function nevals
        shouldDrawPlots,
        plotColor, % plot color for method
        convergancePlot, % instance of ConvergancePlot
        trajectoryPlot; % instance of TrajectoryPlot
    end
    
    methods(Abstract)
        optimizationInit(self) % initialization before optimization loop
        optimizationLoopCondition(self) 
        optimizationStep(self) % optimization loop commands and computations 
        % OUTPUT ARGUMENTS
        %  optimizationPoints is a array of struct that contain x and f
        %  neval - number of function evaluations
        [coordinates, functionValues, functionNevals] = optimizationResult(self) % final step after optimization loop
    end
    
    methods
        function self = AbstractMethod(func, options)
            %ABSTRACTMETHOD Construct an instance of this class
            self.objectiveFunc = func;
            self.iterationMax = options.iterationMax;
            self.tol = options.tol;
            self.iteration = 1;
            self.dx = realmax;
            self.shouldDrawPlots = options.shouldDrawPlots;
            self.plotColor = options.plotColor;
            if (self.shouldDrawPlots == true)
                self.trajectoryPlot = options.trajectoryPlot;
                self.convergancePlot = options.convergancePlot;
            end
        end
        
        % x0 - starting point
        function [coordinates, functionValues, functionNevals] = optimization(self, x0)
            self.objectiveFunc.clearEvalCount();
            self.x0 = x0;
            self = self.optimizationInit();
            
            while(self.optimizationLoopCondition())
                try 
                    self = self.optimizationStep();
                catch ME
                    disp('Error Message:')
                    disp(ME.message)
                    coordinates = -1; 
                    functionValues = -1;
                    functionNevals = -1;
                    return
                end
            end
            
            [coordinates, functionValues, functionNevals] = self.optimizationResult();
            if self.shouldDrawPlots
                self.drawPlots();
            end
        end
        
        function drawPlots(self)
            TraectoryPlot.initiate(self.objectiveFunc);
            TraectoryPlot.draw(self.coordinates, self.deltas);

            ConvergancePlot.initiate();
            ConvergancePlot.draw(self.funNevals, self.funValues);
        end
    end
end

