function U = unpack(cell_array)

    nb_items = size(cell_array, 1);
    nb_lines = zeros(nb_items, 1);
    for i = 1:nb_items
        nb_lines(i) = size(cell_array{i}, 1);
    end
    
    U = zeros(sum(nb_lines), size(cell_array{1}, 2));
    next = 1;
    for i = 1:nb_items
        last = next + nb_lines(i) - 1;
        U(next:last, :) = cell_array{i};
        next = next + nb_lines(i);
    end
end