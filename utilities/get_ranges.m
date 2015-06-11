function [ranges values] = get_ranges(data)
% return ranges of similar values from a matrix

ranges = [];
values = [];
i_first = 1;

switch class(data)
    case 'double'
        for i = 2:length(data)
            if data(i) ~= data(i - 1)
                ranges = [ranges; i_first, (i - 1)];
                values = [values; data(i-1)];
                i_first = i;
            end
        end
    case 'cell'
        for i = 2:length(data)
            if ~strcmp(data(i), data(i - 1))
                ranges = [ranges; i_first, (i - 1)];
                values = [values; data(i-1)];
                i_first = i;
            end
        end
end

ranges = [ranges; i_first, i];
values = [values; data(i)];