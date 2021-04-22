classdef ConvergancePlot < AbstractPlot
    % ConvergancePlot build plot best function value found / number of function evaluation
    
    methods
        function self = ConvergancePlot(sleepTime)
            self = self@AbstractPlot(sleepTime, 2);
        end
        
        function initiate(self, parameters)
            self.setParameters(parameters);
            % initialization of plot
            figure(2);
            hold on
            xlabel('$Number of Function Evaluations$','interpreter','latex','FontSize',13);
            ylabel('$Best Function Value Found$','interpreter','latex','FontSize',13);
        end
        
        function draw(self, realMin, evals, fValues)
            % draw line after optimization's loop step
            figure(2);
            
            fVal = fValues;
            if (realMin < 0)
                fVal = fVal - realMin;
            end
            
            for i = 1 : size(evals, 2) - 1
                line([evals(i), evals(i + 1)], ... 
                    [log(fVal(i)), log(fVal(i + 1))], 'LineWidth', 1, 'Color', self.currentColor, 'Marker', 's');
            end
        end
    end
end

