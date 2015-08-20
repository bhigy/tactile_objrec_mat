% Preparing haptic data

if ~exist('formalized_filename', 'var') || isempty(formalized_filename)
    error('Unknownk variable "formalized_filename"');
end
if ~exist('filtered_filename', 'var') || isempty(filtered_filename)
    error('Unknownk variable "filtered_filename"');
end
if ~exist('use_finger', 'var') || isempty(use_finger)
    error('Unknownk variable "use_finger"');
end
if ~exist('use_data', 'var') || isempty(use_data)
    error('Unknownk variable "use_data"');
end
    
%% Parameters
cols_thumb           = [52:63, 156:167, 212, 217:219];
cols_index           = [4:15, 108:119, 213, 220:221];
cols_middle          = [16:27, 120:131, 214, 222:223];
cols_ring_and_little = [28:39, 40:51, 132:143, 144:155, 215, 216, 224];
cols_palm            = [64-107, 168-211];

load([root, splitted_filename]);

%% Removing some unwanted columns
keep_column = ones(size(S.X, 2), 1);

if use_finger(1) == 0
    keep_column(cols_thumb) = 0;
end
if use_finger(2) == 0
    keep_column(cols_index) = 0;
end
if use_finger(3) == 0
    keep_column(cols_middle) = 0;
end
if use_finger(4) == 0
    keep_column(cols_ring_and_little) = 0;
end

if use_data(1) == 0
    keep_column(cols_analog) = 0;
end
if use_data(2) == 0
    keep_column(cols_skin) = 0;
end
if use_data(3) == 0
    keep_column(cols_skin_comp) = 0;
end
if use_data(4) == 0
    keep_column(cols_springy) = 0;
end
if use_data(5) == 0
    keep_column(cols_state) = 0;
end

i_keep = find(keep_column);
S.X = S.X(:, i_keep);
no_test.X = no_test.X(:, i_keep);
training.X = training.X(:, i_keep);
validation.X = validation.X(:, i_keep);
test.X = test.X(:, i_keep);

save([root, filtered_filename], 'S', 'no_test', 'training', 'validation', 'test', 'objects');