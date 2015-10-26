classdef Points
    properties
        X
        Y
    end
    
    methods(Static)
        function m = marker(value)
            persistent marker;
            if isempty(marker)
                marker = '+';
            end
            
            if exist('value', 'var') && ~isempty(value)
                marker = value;
            end
            
            m = marker;
        end
    end
    
    methods
        function obj = Points(X, Y)
            obj.X = X;
            obj.Y = Y;
        end
        
        function draw(obj, grouping, labels)
            if isempty(grouping)
                grouping = zeros(length(obj.X), 1);
            end
            
            grps = unique(grouping);
            colors = linspecer(length(grps));
            figure;
            hold all;
            for i = 1:length(grps)
                plot(obj.X(grouping == grps(i)), obj.Y(grouping == grps(i)), 'MarkerEdgeColor', colors(i,:), 'Marker', obj.marker, 'LineStyle', 'none');
            end
            if length(grps) > 1
                if isempty(labels)
                    legend(arrayfun(@(x) {int2str(x)}, grps));
                else
                    legend(labels);
                end
            end
            hold off;
        end
    end
end