classdef LBFGS < AbstractMethod
    %LBFGS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        dim,
        M,
        m,
        s,
        c1,
        interval,
        q0,
        z0,
        p0,
        Ps,
        Ys,
        gams,
        alfs;
    end
    
    methods
        function self = LBFGS(func, options)
            self = self@AbstractMethod(func, options);
            self.interval = [-3; 3];
            self.M = 1;
            self.m = 0;
            self.s = 1;
            self.c1 = 1e-4;
        end
        
        function self = optimizationInit(self)
            self.q0 = self.objectiveFunc.df(self.x0);
            self.z0 = - self.q0; %initial direction
            self.p0 = self.tol; %step difference, tol for passing stop criterion
            
            self.dim = length(self.x0);
            self.Ps = zeros(self.dim, self.M);
            self.Ys = zeros(self.dim, self.M);
            self.gams = zeros(1, self.M);
            self.alfs = zeros(1, self.M);
        end
        
        function outputArg = optimizationLoopCondition(self)
            outputArg = ((norm(self.p0) >= self.tol || norm(self.q0) >= self.tol) && ...
                         (self.iteration < self.iterationMax));
        end
        
        function self = optimizationStep(self)
            self.fValue = self.objectiveFunc.f(self.x0); % поправить чтобы не считалось eval
            
            self.coordinates(self.iteration, :) = self.x0;
            self.functionValues(self.iteration) = self.fValue;
            self.functionNevals(self.iteration) = self.objectiveFunc.evaluationCount;
            
            f1dim = @(al)(self.objectiveFunc.f(self.x0 + al*self.z0));
            [al,~,~] = goldensectionsearch(f1dim, self.interval, self.tol);
            
            self.p0 = al*self.z0;
            x1 = self.x0 + self.p0; %quasi-Newton coordinate update
            q1 = self.objectiveFunc.df(x1); %new derivative
            
            if self.m < self.M
                self.m = self.m + 1;
            end
            
            self.Ps = circshift(self.Ps, 1, 2);
            self.Ys = circshift(self.Ys, 1, 2);
            self.gams = circshift(self.gams, 1, 2);
            
            self.Ps(:,1) = self.p0;
            y0 = q1 - self.q0;
            self.Ys(:,1) = y0;
            self.gams(1) = 1/(y0'*self.p0);
            
            %recurrect calculations
            q = q1;
            delta = self.p0'*y0/(y0'*y0);
            for i = 1:self.m %go backwards in time
                self.alfs(i) = self.gams(i)*self.Ps(:,i)'*q;
                q = q - self.alfs(i)*self.Ys(i);
            end
            z = delta*q;
            for i = self.m:-1:1 %go forwards in time
                bet = self.gams(i)*self.Ys(:,i)'*z;
                z = z + (self.alfs(i) - bet)*self.Ps(:,i);
            end
            
            self.z0 = -z;
            self.x0 = x1;
            self.q0 = q1;
            
            self.iteration = self.iteration + 1;
        end
        
        function [coordinates, functionValues, functionNevals] = optimizationResult(self)
            coordinates = self.coordinates;
            functionValues = self.functionValues;
            functionNevals = self.functionNevals;
        end
        
        function drawPlots(self)
            options.description = strcat('LFBGS,', num2str(self.iteration - 1), ' iterations');
            options.color = self.plotColor;
            deltas = zeros(1, length(self.coordinates));
            self.trajectoryPlot.initiate(self.objectiveFunc, options);
            self.trajectoryPlot.draw(self.coordinates, deltas);

            self.convergancePlot.initiate(options);
            self.convergancePlot.draw(self.objectiveFunc.realMin, self.functionNevals, self.functionValues);
        end
    end
end

