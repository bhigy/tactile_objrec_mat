% Main script controlling the overall pipeline
addpath(genpath('/home/bhigy/dev/tactile_objrec_mat'));
init;

%% Parameters
SET_PRETEST = 1;

set = SET_PRETEST;  % set to be used

% Branching parameters
do_load    = 0;
do_analyse = 0;

init_haptic_data;

if do_load == 1
    disp('-- Loading raw data');
    load_haptic_data;
end

disp('-- Merging raw data');
merge_haptic_data;

disp('-- Splitting data into training, validation and test set');
split_haptic_data;

disp('-- Preparing data for analysis');
use_finger = [1 0 1 0];
use_data   = [1 0 1 1 1];
prepare_haptic_data;

if do_analyse == 1
    disp('-- Analysing data');
    analyze_haptic_data;
end