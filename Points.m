classdef Points
    properties
        X
        Y
    end
    
    methods
        function obj = Points(X, Y)
            obj.X = X;
            obj.Y = Y;
        end
        
        function draw(obj, grouping)
            if isempty(grouping)
                grouping = zeroes(length(obj.X), 1);
            end
            
            grps = unique(grouping);
%             colors = hsv(length(grps));
            colors = linspecer(length(grps));
            figure;
            hold all;
            for i = 1:length(grps)
                plot(obj.X(grouping == grps(i)), obj.Y(grouping == grps(i)), 'MarkerEdgeColor', colors(i,:), 'Marker', '.', 'LineStyle', 'none');
            end
            if length(grps) > 1
                legend(arrayfun(@(x) {int2str(x)}, grps));
            end
            hold off;
        end
    end
end