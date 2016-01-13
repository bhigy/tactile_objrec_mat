function C = hd_extract_col(data, cols)

    % Extract requested cols and turn them into rows
    C = cell(size(data, 1), 1);
    for i = 1:size(data, 1)
        C{i} = data{i}(:, cols)';
    end
end