classdef TrustRegionDeltaPlot
    % TrustRegionDeltaPlot draws circles with radius delta. Class is used in
    % trust region optimization method.
    
    methods(Static)
        function deltaDraw(x0, y0, delta)
            % draws circle in point [x0, y0] with radius delta
            % chose traectory figure
            figure(1);
            r=delta;

            color = [0 0.4470 0.7410];
            rectangle('Position',[x0-r,y0-r,2*r,2*r],'Curvature',[1 1],'FaceColor',[color, 0.1],'EdgeColor','none')
        end
    end
end

