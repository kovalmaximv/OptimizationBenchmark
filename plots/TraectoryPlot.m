classdef TraectoryPlot
    % Traectory plot draw traectory of optimization
    
    methods(Static)        
        function draw(coordinates)
            % draws first blue point of traectory
            figure(1);
            x0 = coordinates(1, :);
            scatter(x0(1),x0(2),'bs','MarkerFaceColor',[0 0 1]);
            text(x0(1) + 0.2, x0(2) - 0.2, num2str(0),'FontSize',11,'interpreter','latex');
            
            % draws line from x0 to x1
            for i = 1 : size(coordinates, 1) - 1
                x0 = coordinates(i, :);
                x1 = coordinates(i + 1, :);
                line([x0(1) x1(1)],[x0(2) x1(2)],'LineWidth',1,'Color','blue','Marker','s');
            end
             
            % draws red dot when optimization finished
            x1 = coordinates(size(coordinates, 1), :);
            text(x1(1) + 0.2, x1(2) - 0.2, num2str(size(coordinates, 1)),'FontSize',11,'interpreter','latex');
            scatter(x1(1),x1(2),'ro','MarkerFaceColor',[1 0 0]);
        end
        
        function initiate(abstractFunction)
            % настраиваем оси x и y
            x1 = (-5:0.1:5); m = length(x1);
            y1 = (-5:0.1:5); n = length(y1);

            % делаем сетку
            [xx, yy] = meshgrid(x1,y1);
            
            % массивы для графиков функции и ее производных по x и y
            F = zeros(n,m);
            dFx = zeros(n,m);
            dFy = zeros(n,m);
            
            % вычисляем рельеф поверхности
            for i = 1:n
                for j = 1:m
                    F(i,j) = feval(abstractFunction.objectiveFunction, [xx(i,j),yy(i,j)]);
                    v = abstractFunction.df([xx(i,j),yy(i,j)]);
                    dFx(i,j) = v(1);
                    dFy(i,j) = v(2);
                end
            end
            
            figure(1);
            hold on
            
            % для контурного графика:
            nlevels = 30;  %число линий уровня
            [M,c] = contour(xx,yy,F,nlevels);
            c.LineWidth = 1;
            
            axis square % делаем оси одинаковыми
            % форматируем оси
            xlabel('$x$','interpreter','latex','FontSize',13);
            ylabel('$y$','interpreter','latex','FontSize',13);
            set(1,'position',[100 30 660 600]);
            set(gca,'TickLabelInterpreter','latex','FontSize',11);
        end
    end
end

