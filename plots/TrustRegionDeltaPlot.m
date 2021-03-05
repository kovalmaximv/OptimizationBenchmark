classdef TrustRegionDeltaPlot < TraectoryPlot
    % TrustRegionDeltaPlot draws circles with radius delta. Class is used in
    % trust region optimization method.
    
    methods(Static)
        function draw(coordinates, deltas)
            % draws first blue point of traectory
            figure(1);
            color = [0 0.4470 0.7410];
            
            x0 = coordinates(1, :);
            r=deltas(1);
            scatter(x0(1),x0(2),'bs','MarkerFaceColor',[0 0 1]);
            text(x0(1) + 0.2, x0(2) - 0.2, num2str(0),'FontSize',11,'interpreter','latex');
            rectangle('Position',[x0(1)-r,x0(2)-r,2*r,2*r],'Curvature',[1 1],'FaceColor',[color, 0.1],'EdgeColor','none')
            
            % draws line from x0 to x1
            for i = 1 : size(coordinates, 1) - 1
                x0 = coordinates(i, :);
                x1 = coordinates(i + 1, :);
                r=deltas(i + 1);
                line([x0(1) x1(1)],[x0(2) x1(2)],'LineWidth',1,'Color','blue','Marker','s');
                rectangle('Position',[x1(1)-r,x1(2)-r,2*r,2*r],'Curvature',[1 1],'FaceColor',[color, 0.1],'EdgeColor','none')
                pause(0.25);
            end
             
            % draws red dot when optimization finished
            x1 = coordinates(size(coordinates, 1), :);
            text(x1(1) + 0.2, x1(2) - 0.2, num2str(size(coordinates, 1)),'FontSize',11,'interpreter','latex');
            scatter(x1(1),x1(2),'ro','MarkerFaceColor',[1 0 0]);
        end
    end
end

