function C = hd_extract_col(data, col)

    C = cell(size(data, 1), 1);
    for i = 1:size(data, 1)
        C{i} = data{i}(:, col)';
    end
end