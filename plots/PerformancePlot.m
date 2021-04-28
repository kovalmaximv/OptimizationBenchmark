classdef PerformancePlot < AbstractPlot
    
    properties
        i = 0, % current func iteration
        j = 0, % current method iteration
        funcsName = [""], % array of func names
        methodsName = [""], % array of method names
        tps, % Tps array, keeps method-convergance information
        rps; % Rps array, keeps calculated performance
    end
    
    methods
        function initiate(self)
            % initialization of plot
            figure(self.figureNum);
            hold on
            xlabel('$\tau$','interpreter','latex','FontSize',13);
            ylabel('$\rho_s(\tau)$','interpreter','latex','FontSize',13);
        end
        
        function calculateRps(self)
            for iter = 1 : length(self.tps(:, 1))
                minTps = min(self.tps(iter, :));
                for jter = 1 : length(self.tps(iter, :))
                    if self.tps(iter, jter) ~= -1
                        self.rps(iter, jter) = self.tps(iter, jter) / minTps; 
                    else
                        self.rps(iter, jter) = intmax;
                    end
                    
                end
            end
        end
        
        function initiateFunc(self, funcName)
            self.i = self.i + 1;
            self.j = 0;
            self.funcsName(self.i) = funcName;
        end
        
        function keepConvergance(self, convergance)
            self.j = self.j + 1;
            self.tps(self.i, self.j) = convergance(end);
        end
        
        function initiateMethod(self, methodName)
            self.methodsName(self.j) = methodName;
        end
        
        function drawPlot(self)
            figure(self.figureNum);
            hold on;
            tetta = 0:50;
            pst = zeros(length(tetta), 1);
            pst(1) = 0;
            funcCount = length(self.tps);
            
            for funcNum = 1 : length(self.rps(1, :))
                for k = 1 : length(tetta)
                    pst(k) = sum(self.rps(:, funcNum) <= tetta(k)) / funcCount;
                end
                plot(tetta, pst, '-x', 'DisplayName', self.methodsName(funcNum))
                pst = zeros(length(tetta), 1);
            end
            
            legend;
        end
    end
end

