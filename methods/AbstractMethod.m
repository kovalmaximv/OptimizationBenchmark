classdef AbstractMethod
    % ABSTRACTMETHOD Abstract class that all real methods must extend 
    
    properties
        objectiveFunc, % AbstractFunction object. Contains objective func and der func
        iteration, % current iteration
        iterationMax, % max iteration num when alg must stop
        dx, % X difference between two steps
        tol, % tolerance that used in stop criteria with dx
        x0, x1, % array of coordinates. x0 - prev, x1 - current
        fValue, fValuePrev; % value of objective function. Current and previous.
    end
    
    methods(Abstract)
        optimizationInit(self) % initialization before optimization loop
        optimizationLoopCondition(self) 
        optimizationStep(self) % optimization loop commands and computations 
        % OUTPUT ARGUMENTS
        %  xmin is a function minimizer
        %  fmin = f(xmin)
        %  neval - number of function evaluations
        [xmin, fmin, neval] = optimizationResult(self) % final step after optimization loop
    end
    
    methods
        function self = AbstractMethod(funcCLass, iterationMax, tol)
            %ABSTRACTMETHOD Construct an instance of this class
            self.objectiveFunc = funcCLass;
            self.iterationMax = iterationMax;
            self.tol = tol;
            self.iteration = 1;
            self.dx = realmax;
            self.fValue = 0;
            self.fValuePrev = 0;
        end
        
        % x0 - starting point
        function [xmin, fmin, neval] = optimization(self, x0)
            self.x0 = x0;
            self.x1 = x0;
            self = self.optimizationInit();
            % initialization and first draw of traectory plot
            TraectoryPlot.initiate(self.objectiveFunc);
            TraectoryPlot.firstDraw(self.x0);
            while(self.optimizationLoopCondition())
                self = self.optimizationStep();
                % draw traectory line 
                TraectoryPlot.draw(self.x0, self.x1);
                % checking if it isn't the first iteration
                if self.objectiveFunc.storedEvaluationCount > 0
                    % draw convergance line
                    ConvergancePlot.draw(self.objectiveFunc.evaluationCount, ...
                        self.objectiveFunc.storedEvaluationCount, self.fValue, self.fValuePrev);
                end
                % after we draw convergance line, we need update
                % evaluation count in AbstractFunction object.
                self.objectiveFunc.storedEvaluationCount = ....
                    self.objectiveFunc.evaluationCount;
            end
            % final red dot in traectory plot
            TraectoryPlot.finalDraw(self.x1, self.iteration);
            [xmin, fmin, neval] = self.optimizationResult();
        end
    end
end

