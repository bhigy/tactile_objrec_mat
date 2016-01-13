 function [N, M, S] = hd_compute_moments(data)

    nb_items = size(data, 1);
    M = cell(nb_items, 1);
    S = cell(nb_items, 1);
    N = cell(nb_items, 1);
    for i = 1:nb_items
        M{i} = mean(data{i}, 1);
        S{i} = std(data{i}, 0, 1);
        N{i} = sum(data{i} > 0, 1);
    end
end