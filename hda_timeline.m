% Analysing springy values
addpath(genpath('/home/bhigy/dev/tactile_objrec_mat'));
init;

%% Parameters
SET_PRETEST          = 1;
COL_ANALOG_1         = 3;
COL_ANALOG_2         = 4;
COL_ANALOG_3         = 5;
COL_SPRINGY_THUMB    = 3;
COL_SPRINGY_MIDDLE   = 5;
COL_STATE_THUMB_1    = 11;
COL_STATE_THUMB_2    = 12;
COL_STATE_THUMB_3    = 13;
COL_STATE_MIDDLE_1   = 16;
COL_STATE_MIDDLE_2   = 17;
COL_SKIN_COMP_MIDDLE = 15:26;
OBJ_ONE_EACH         = 7;
OBJ_TWO_EACH         = 8;
OBJ_SOFT_BALL        = 1;
OBJ_BALL             = 2;
OBJ_BOTTLE           = 3;
OBJ_DINOSAUR         = 4;
OBJ_BOX              = 5;
OBJ_SPONGE           = 6;

set = SET_PRETEST;  % set to be used
col = COL_ANALOG_2;
obj = OBJ_TWO_EACH;

hd_init;

load([root, raw_filename]);
M   = analog;

switch obj
    case OBJ_ONE_EACH
        lines_to_remove = [2:10, 12:20, 22:30, 32:40, 42:50, 52:60];
    case OBJ_TWO_EACH
        lines_to_remove = [3:10, 13:20, 23:30, 33:40, 43:50, 53:60];
    case OBJ_SOFT_BALL
        lines_to_remove = 11:60;
    case OBJ_BALL
        lines_to_remove = [1:10, 21:60];
    case OBJ_BOTTLE
        lines_to_remove = [1:20, 31:60];
    case OBJ_DINOSAUR
        lines_to_remove = [1:30, 41:60];
    case OBJ_BOX
        lines_to_remove = [1:40, 51:60];
    case OBJ_SPONGE
        lines_to_remove = 1:50;
end


%% Analysis
labels = erase(labels, invalid_trials);
labels = erase(labels, lines_to_remove);

[~, starting_lines] = find_closest(labels{2}, events{2});
ending_lines = starting_lines + 2;

figure;
hold on;
% L = [];
for i = 1:length(starting_lines)
    lines = find_between(events{2}(starting_lines(i)), events{2}(ending_lines(i)), M(:, 2));
    if length(col) == 1
        plot(M(lines,col));
%         l = M(lines, col);
%         L = [L, l(1:600)];
    else
        plot(mean(M(lines,col), 2));
    end
end
legend(labels{3});
hold off;


