% Loading haptic data

if ~exist('root', 'var') || isempty(root)
    error('Unknownk variable "root"');
end
if ~exist('raw_filename', 'var') || isempty(raw_filename)
    error('Unknownk variable "raw_filename"');
end
if ~exist('formalized_filename', 'var') || isempty(formalized_filename)
    error('Unknownk variable "formalized_filename"');
end
if ~exist('invalid_trials', 'var') || isempty(invalid_trials)
    error('Unknownk variable "invalid_trials"');
end

%% Parameters
nb_mesures     = 1;    % number of mesures per grasp used for computing the mean
grasp_duration = 2;    % duration of the grasp

c_analog   = 3:5;
c_skin     = [3:14, 15:26, 27:38, 39:50, 51:62, 99:109, 111:121, 123:133, 135:141, 143:146];
c_springy  = 3:7;
c_state    = 11:18;


%% Loading data
load([root, raw_filename]);


%% Filtering lines
% Removing invalid trials
labels = erase(labels, invalid_trials);

% Selectin the mesures to keep
% 1 - Finding the closest event which should be the close command
[~, lines] = findClosest(labels{2}, events{2});
% 2 - Going to the second next event, which should be the home command
lines = lines + 2;
t_home = events{2}(lines);
% 3 - Taking mesures in the middle of the grasp (tHome - duration / 2)
if(nb_mesures == 1)
    t_mesures = t_home - grasp_duration / 2;
else
    t_mesures = zeros(length(t_home) * nb_mesures, 1);
    for i = 1:length(t_home)
        tMiddle = t_home(i) - grasp_duration / 2;
        nb_steps = nb_mesures - 1;
        step = grasp_duration / (2 * nb_steps);
        first = tMiddle - (nb_steps * step / 2);
        last  = tMiddle + (nb_steps * step / 2);
        j_first = (i - 1) * nb_mesures + 1;
        j_last  = j_first + nb_steps;
        t_mesures(j_first:j_last) = first:step:last;
    end
end
[~, i_analog]   = findClosest(t_mesures, analog(:, 2));
[~, i_state]    = findClosest(t_mesures, state(:, 2));
[~, i_springy]  = findClosest(t_mesures, springy(:, 2));
[~, i_skin]     = findClosest(t_mesures, skin(:, 2));
[~, i_skinComp] = findClosest(t_mesures, skinComp(:, 2));
% 4 - Taking the mean of the mesures (if we took several) for each grasp
if(nb_mesures == 1)
    analog_filtered    = analog(i_analog, :);
    state_filtered     = state(i_state, :);
    springy_filtered   = springy(i_springy, :);
    skin_filtered      = skin(i_skin, :);
    skin_comp_filtered = skinComp(i_skinComp, :);
else
    analog_filtered    = zeros(length(t_home), size(analog, 2));
    state_filtered     = zeros(length(t_home), size(state, 2));
    springy_filtered   = zeros(length(t_home), size(springy, 2));
    skin_filtered      = zeros(length(t_home), size(skin, 2));
    skin_comp_filtered = zeros(length(t_home), size(skinComp, 2));
    for i = 1:length(t_home)
        j_first = (i - 1) * nb_mesures + 1;
        j_last  = j_first + nb_mesures - 1;
        analog_filtered(i, :)    = mean(analog(i_analog(j_first:j_last), :), 1);
        state_filtered(i, :)     = mean(state(i_state(j_first:j_last), :), 1);
        springy_filtered(i, :)   = mean(springy(i_springy(j_first:j_last), :), 1);
        skin_filtered(i, :)      = mean(skin(i_skin(j_first:j_last), :), 1);
        skin_comp_filtered(i, :) = mean(skinComp(i_skinComp(j_first:j_last), :), 1);
    end
end


%% Merging data
nb_rows = size(analog_filtered, 1);
nb_cols = length(c_analog) + 2 * length(c_skin) + length(c_springy) + length(c_state);
merged_data = zeros(nb_rows, nb_cols);
merged_data(:, cols_analog)    = analog_filtered(:, c_analog);
merged_data(:, cols_skin)      = skin_filtered(:, c_skin);
merged_data(:, cols_skin_comp) = skin_comp_filtered(:, c_skin);
merged_data(:, cols_springy)   = springy_filtered(:, c_springy);
merged_data(:, cols_state)     = state_filtered(:, c_state);


%% Saving the data
X = merged_data;
real_labels = labels(3);
real_labels = real_labels{1};
objects = unique(real_labels);
Y = zeros(length(real_labels), 1);
for i = 1:length(real_labels)
    Y(i) = find(arrayfun(@(x) isequal(objects(x), real_labels(i)), 1:length(objects)));
end

save([root, formalized_filename], 'X', 'Y', 'objects');