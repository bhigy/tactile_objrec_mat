function cell_array_out = erase(cell_array , line_numbers)
% Erase a line of a vector of cell arrays

    cell_array_out = cell_array;
    for i = 1:size(cell_array, 2)
        cell_array_out{:, i}(line_numbers) = [];
    end

end

