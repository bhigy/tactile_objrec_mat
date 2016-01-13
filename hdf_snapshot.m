function F = hdf_snapshot(data, timestamps, cols)

    F = zeros(size(data, 1), length(cols));
    
    for i = 1:length(data)
        D = data{i};
        [~, i_snapshot] = find_closest(timestamps(i), D(:, 1));
        F(i, :) = D(i_snapshot, cols);
    end 
end