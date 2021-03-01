classdef ConvergancePlot
    % ConvergancePlot build plot best function value found / number of function evaluation
    
    methods(Static)
        function initiate()
            % initialization of plot
            figure(2);
            hold on
            xlabel('$x$','interpreter','latex','FontSize',13);
            ylabel('$y$','interpreter','latex','FontSize',13);
            ylim([0 1]);
        end
        
        function draw(evalCount, storedEvalCound, fValue, fValuePrev)
            % draw line after optimization's loop step
            figure(2);
            line([storedEvalCound, evalCount], ... 
                [fValuePrev, fValue],'LineWidth',1,'Color','blue','Marker','s');
            ylim([0 1]);
        end
    end
end

