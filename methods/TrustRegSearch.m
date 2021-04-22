classdef TrustRegSearch < AbstractMethod
    % TRUSTREGSEARCH trust region method with visualization
    %  plots optimization path on current axis
    %  x must be not less then 2-dimensional
    %  TRUSTREGSEARCH searches for minimum using Newton multidimensional method
    
    properties
        delta, % initial radius
        deltamax, % max radius
        eta,
        deltas, % delta history
        B0; 
    end
    
    methods
        % func - AbstractFunction extended object
        % options structures:
        % - options.iterationMax
        % - options.tol
        % - options.shouldDrawPlots true - plot draws, false - dont
        % - options.trajectoryPlot trajectoryPlot object
        % - options.plotColor WARNING: only one letter color e.g.: b,r,g..
        function self = TrustRegSearch(func, options)
            %TRUSTREGSEARCH Construct an instance of this class
            % call superclass constructor
            self = self@AbstractMethod(func, options);
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
            % find coefficients for the model
            g0 = self.objectiveFunc.df(self.x0);
            f0 = self.objectiveFunc.f(self.x0);
            self.fValue = f0;
            
            self.coordinates(self.iteration, :) = self.x0;
            self.functionValues(self.iteration) = self.fValue;
            self.functionNevals(self.iteration) = self.objectiveFunc.evaluationCount;
            self.deltas(self.iteration) = self.delta;
            % добавить про function nevals
            
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
            
            % TrustRegionDeltaPlot.deltaDraw(self.x1(1), self.x1(2), self.delta);
            self.iteration = self.iteration + 1;
        end
        
       
        function [coordinates, functionValues, functionNevals] = optimizationResult(self)
            coordinates = self.coordinates;
            functionValues = self.functionValues;
            functionNevals = self.functionNevals;
        end
        
        
        function drawPlots(self)
            options.description = strcat('TrustRegion,', num2str(self.iteration - 1), ' iterations');
            options.color = self.plotColor;
            self.trajectoryPlot.initiate(self.objectiveFunc, options);
            self.trajectoryPlot.draw(self.coordinates, self.deltas);

            self.convergancePlot.initiate(options);
            self.convergancePlot.draw(self.objectiveFunc.realMin, self.functionNevals, self.functionValues);
        end
    end
    
    methods(Static)
        function pmin = doglegsearch(mod,g0,B0,Delta,tol)
        %dogleg local search
        pU = -g0'*g0/(g0'*B0*g0)*g0;
        
        warning('') % Clear last warning message
        pB = - B0^-1*g0;
        [warnMsg, ~] = lastwarn;
        if ~isempty(warnMsg)
            error('Matrix is close to singular: %s', warnMsg);
        end
        
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
    end
end

