function drawGroups(P, C, labels)
% drawGroups Draw groups of points in different colors
%   P:      (n x 2 matrix) points to draw
%   C:      (n x 1 matrix) grouping id
%   labels: (m x 1 matrix) groups labels

    if isempty(C)
        C = zeroes(size(P), 1);
    end

    categories = unique(C);
    colors = linspecer(length(categories));
    figure;
    hold all;
    for i = 1:length(categories)
        subP = P(C == categories(i), :);
        plot(subP(:, 1), subP(:, 2), 'MarkerEdgeColor', colors(i,:), 'Marker', '+', 'LineStyle', 'none');
    end
    if length(categories) > 1
        if isempty(labels)
            legend(arrayfun(@(x) {int2str(x)}, categories));
        else
            legend(labels);
        end
    end
    hold off;
end

