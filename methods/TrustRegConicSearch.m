classdef TrustRegConicSearch < AbstractMethod
    
    properties
        delta, % initial radius 
        deltamax, % max radius 
        eta, 
        deltas, % delta history
        B0; 
    end
    
    methods
        function self = TrustRegConicSearch(funcClass, options)
            self = self@AbstractMethod(funcClass, options);
            self.delta = 1;
            self.deltamax = 1;
            self.eta = 0.1;
        end
        
        function outputArg = optimizationLoopCondition(self)
            outputArg = ((norm(self.dx) >= self.tol) && (self.iteration < self.iterationMax));
        end
        
        function self = optimizationInit(self)
            self.B0 = eye(2);
        end
        
        function self = optimizationStep(self)
            % если x0 = x1, то conic step зациклится, в таком случае нужно
            % использовать стандартный trust region step
            if (self.iteration > 1) && (self.coordinates(end) ~= self.coordinates(end - 1))
                self = conicOptimizationStep(self);
            else
                self = regularTrustRegionOptimizationStep(self);
            end
        end
        
        
        function self = regularTrustRegionOptimizationStep(self)
            % find coefficients for the model
            g0 = self.objectiveFunc.df(self.x0);
            f0 = self.objectiveFunc.f(self.x0);
            self.fValue = f0;
            
            self.coordinates(self.iteration, :) = self.x0;
            self.functionValues(self.iteration) = self.fValue;
            self.functionNevals(self.iteration) = self.objectiveFunc.evaluationCount;
            
            mod = @(p)(f0 + p'*g0 + 0.5*p'*self.B0*p); %model
            pmin = TrustRegSearch.doglegsearch(mod, g0, self.B0, self.delta, self.tol);
            rho = (f0 - self.objectiveFunc.f(self.x0 + pmin))/(mod([0;0]) - mod(pmin));
            
            %update x
            if rho > self.eta
                self.x0 = self.x0 + pmin;
                self.dx = pmin;
        
                %BFGS update
                y = self.objectiveFunc.df(self.x0) - g0; 
                self.B0 = self.B0 + y*y'/(y'*pmin) - ...
                    (self.B0*pmin)*pmin'*self.B0'/(pmin'*self.B0*pmin);
            else
                self.x0 = self.x0;
            end
            
            %update trust region radius
            if rho < 0.25
                self.delta = 0.25*self.delta;
            elseif (rho > 0.75 && abs(norm(pmin) - self.delta) < self.tol)
                self.delta = min([2*self.delta, self.deltamax]);
            end
            
            self.deltas(self.iteration) = self.delta;
            % TrustRegionDeltaPlot.deltaDraw(self.x1(1), self.x1(2), self.delta);
            self.iteration = self.iteration + 1;
        end
        
        
        function self = conicOptimizationStep(self) 
            xOld = self.coordinates(self.iteration - 1, :)';
            
            % find coefficients for the model
            g0 = self.objectiveFunc.df(self.x0);
            f0 = self.objectiveFunc.f(self.x0);
            H0 = self.objectiveFunc.hesF(self.x0);
            self.fValue = f0;
            
            self.coordinates(self.iteration, :) = self.x0;
            self.functionValues(self.iteration) = self.fValue;
            self.functionNevals(self.iteration) = self.objectiveFunc.evaluationCount;
            
            h = TrustRegConicSearch.findH(self.x0, xOld, self.objectiveFunc);
            
            mod = @(s)(f0 + (g0' * s)/(1 - h'*s) + (s'*H0*s)/(1 - h'*s)^2); %model от s
            mods = @(x)(mod(x - self.x0)); % model от x
            pmin = TrustRegSearch.doglegsearch(mods, g0, H0, self.delta, self.tol);
            rho = (f0 - self.objectiveFunc.f(self.x0 + pmin))/(mods([0;0]) - mods(pmin));
            
            %update x
            if rho > self.eta
                self.x0 = self.x0 + pmin;
                self.dx = pmin;
        
                %BFGS update
                y = self.objectiveFunc.df(self.x0) - g0; 
                self.B0 = self.B0 + y*y'/(y'*pmin) - ...
                    (self.B0*pmin)*pmin'*self.B0'/(pmin'*self.B0*pmin);
            else
                self.x0 = self.x0;
            end
            
            %update trust region radius
            if rho < 0.25
                self.delta = 0.25*self.delta;
            elseif (rho > 0.75 && abs(norm(pmin) - self.delta) < self.tol)
                self.delta = min([2*self.delta, self.deltamax]);
            end
            
            self.deltas(self.iteration) = self.delta;
            self.iteration = self.iteration + 1;
        end
        
        
        function [coordinates, functionValues, functionNevals] = optimizationResult(self)
            coordinates = self.coordinates;
            functionValues = self.functionValues;
            functionNevals = self.functionNevals;
        end
        
        
        function drawPlots(self)
            TrustRegionDeltaPlot.initiate(self.objectiveFunc);
            TrustRegionDeltaPlot.draw(self.coordinates, self.deltas);

            ConvergancePlot.initiate();
            ConvergancePlot.draw(self.functionNevals, self.functionValues);
        end
    end
    
    methods(Static)
        function pmin = doglegsearch(mod,g0,B0,Delta,tol)
            %dogleg local search
            pU = -g0'*g0/(g0'*B0*g0)*g0;
            pB = - B0^-1*g0;
            al = goldensectionsearch( @(al)( mod(al*pB)), [-Delta/norm(pB),Delta/norm(pB)] , tol);
            pB = al*pB;
            tau = goldensectionsearch(@(tau) ...
                (mod(TrustRegSearch.pparam(pU,pB,tau)) ),[0,2],tol);
            pmin = TrustRegSearch.pparam(pU,pB,tau);
            if norm(pmin) > Delta
                pmin = (Delta / norm(pmin)) *pmin;
            end
        end
        
        
        function p = pparam(pU,pB,tau)
            if (tau <= 1)
                p = tau*pU;
            else
                p = pU + (tau - 1)*(pB - pU);
            end
        end
        
        
        function outputArg = findH(x0, x1, abstractFunction)
            s1 = x1 - x0;
            a = abstractFunction.f(x0) - abstractFunction.f(x1);
            b = abstractFunction.df(x0)' * s1;
            c = 0.5 * s1' * abstractFunction.hesF(x0) * s1;
            
            if ((b^2 - 4*a*c) < 0)
                outputArg = 0;
                return;
            end
            
            k1 = (-b + sqrt(b^2 - 4*a*c)) / (2*a);
            k2 = (-b - sqrt(b^2 - 4*a*c)) / (2*a);
            
            if abs(1 - k1) < abs(1 - k2)
                k = k1;
            else
                k = k2;
            end
            
            outputArg = ((1 - k) * s1) / (s1' * s1);
        end
    end
end

