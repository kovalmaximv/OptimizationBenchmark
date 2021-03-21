classdef AbstractPlot < handle
    %ABSTRACTPLOT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        figureNum, % figure num
        sleepTime, % sleep time between line drawing
        colorArray, % array of colors for method plots
        descriptionArray, % array of descriptions for method plots
        plotCount, % count of methods on one plot
        currentDescription, % current plot description
        currentColor; % current color
    end
    
    methods
        function self = AbstractPlot(sleepTime, figureNum)
            self.figureNum = figureNum;
            self.sleepTime = sleepTime;
            self.plotCount = 0;
            self.descriptionArray = [""];
            self.colorArray = [""];
        end
        
        
        function drawLegend(self)
            figure(self.figureNum);
            h = zeros(self.plotCount);
            
            for i = 1 : self.plotCount
                h(i) = plot(NaN, NaN, self.colorArray(i), 'Marker', 'o');
            end
            
            legend(h([1:self.plotCount]), self.descriptionArray);
        end
    end
    
    methods(Access = protected)
        % parameters - struct. Fields: description, color.
        function self = setParameters(self, parameters)
            self.plotCount = self.plotCount + 1;
            self.currentDescription = parameters.description;
            self.currentColor = parameters.color;
            
            self.descriptionArray(self.plotCount) = self.currentDescription;
            self.colorArray(self.plotCount) = self.currentColor;
        end
    end
end

