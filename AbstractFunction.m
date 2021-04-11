classdef AbstractFunction < handle
    %ABSTRACTFUNCTION Summary of this class goes here
    
    properties
        realMin,
        objectiveFunction,
        objectiveDerFunction,
        objectiveFunctionHes,
        evaluationCount, storedEvaluationCount;
    end
    
    methods
        function self = AbstractFunction(realMin, objectiveFunction, objectiveDerFunction, hessian)
            %ABSTRACTFUNCTION Construct an instance of this class
            self.realMin = realMin;
            self.objectiveFunction = objectiveFunction;
            self.objectiveDerFunction = objectiveDerFunction;
            self.objectiveFunctionHes = hessian;
            self.evaluationCount = 0;
            self.storedEvaluationCount = 0;
        end
        
        function outputArg = f(self, inputArg)
            %METHOD1 Summary of this method goes here
            self.evaluationCount = self.evaluationCount + 1;
            outputArg = feval(self.objectiveFunction, inputArg);
        end
        
        function outputArg = df(self, inputArg)
            %METHOD1 Summary of this method goes here
            outputArg = feval(self.objectiveDerFunction, inputArg);
        end
        
        function outputArg = hesF(self, inputArg)
            outputArg = feval(self.objectiveFunctionHes, inputArg);
        end
        
        function clearEvalCount(self)
            self.evaluationCount = 0;
            self.storedEvaluationCount = 0;
        end
    end
end

