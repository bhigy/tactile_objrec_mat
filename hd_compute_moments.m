function [N, M, S] = hd_compute_moments(data, cols)

    nb_items = size(data, 1);
    M = cell(nb_items, 1);
    S = cell(nb_items, 1);
    N = cell(nb_items, 1);
    for i = 1:nb_items
        M{i} = mean(data{i}(:,cols), 2)';
        S{i} = std(data{i}(:,cols), 0, 2)';
        N{i} = sum(data{i}(:,cols) > 0, 2)';
    end
end