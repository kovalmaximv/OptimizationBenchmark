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
            xlabel('$x$','interpreter','latex','FontSize',13);
            ylabel('$y$','interpreter','latex','FontSize',13);
            ylim([0 1]);
        end
        
        function draw(self, evals, fValues)
            % draw line after optimization's loop step
            figure(2);
            
            for i = 1 : size(evals, 2) - 1
                line([evals(i), evals(i + 1)], ... 
                    [fValues(i), fValues(i + 1)], 'LineWidth', 1, 'Color', self.currentColor, 'Marker', 's');
                ylim([0 1]);
            end
        end
    end
end

