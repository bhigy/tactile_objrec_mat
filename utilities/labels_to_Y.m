function [Y, U] = labels_to_Y(labels)
    U = unique(labels);
    Y = zeros(length(U), 1);
    for i = 1:length(labels)
        Y(i) = find(arrayfun(@(x) isequal(U(x), labels(i)), 1:length(U)));
    end
end