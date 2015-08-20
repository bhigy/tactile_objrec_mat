% Main script controlling the overall pipeline
addpath(genpath('/home/bhigy/dev/tactile_objrec_mat'));
init;

%% Parameters
SET_PRETEST = 1;

set = SET_PRETEST;  % set to be used

% Branching parameters
do_load    = 0;
do_merge   = 0;
do_split   = 0;
do_prepare = 1;
do_analyse = 0;

hd_init;


%% Pipeline
if do_load == 1
    disp('-- Loading raw data');
    hd_load;
end

if do_merge == 1
    disp('-- Merging raw data');
    hd_merge;
end

if do_split == 1
    disp('-- Splitting data into training, validation and test set');
    hd_split;
end

if do_prepare == 1
    disp('-- Preparing data for analysis');
    use_finger = [1 0 1 0];
    use_data   = [1 0 1 1 1];
    hd_prepare;
end

if do_analyse == 1
    disp('-- Analysing data');
    hd_analyze_accuracy;
end