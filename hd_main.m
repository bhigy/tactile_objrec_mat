% Main script controlling the overall pipeline
addpath(genpath('/home/bhigy/dev/tactile_objrec_mat'));
init;

%% Parameters
enum.dataset.PRETEST = 1;
enum.dataset.HAPTIC1 = 2;   % Set with 2 fingers and no tactile data
enum.dataset.WEIGH   = 3;
enum.dataset.HAPTIC2 = 4;   % Complete set, bad wrench
enum.dataset.HAPTIC3 = 5;   % No tactile data, no ring and little finger

% Branching parameters
do_load               = 0;
do_extract_actions    = 0;
do_analyse            = 1;

param = hd_init(enum.dataset, enum.dataset.HAPTIC3);

%% Data loading 
if do_load == 1
    disp('-- Loading raw data');
    raw_data = param.loading_routine(param.root);
    
    save([param.root, param.filenames.raw], '-v7.3', 'raw_data');
end

if do_extract_actions == 1
    load([param.root, param.filenames.raw]);
    
    disp('-- Filtering invalid trials');
    raw_data.labels = erase(raw_data.labels, param.invalid_trials);

    disp('-- Extracting actions');
    starting_events = getStartingEvents(raw_data);
    
    % Grasp action
    t_starting_event = raw_data.events{2}(starting_events) + 0.01;
    t_ending_event   = raw_data.events{2}(starting_events + 2);
    grasp = hd_extract_sequence(raw_data, param.raw_cols, t_starting_event, t_ending_event);
    
    % Weigh action
    t_starting_event = raw_data.events{2}(starting_events + 2);
    t_ending_event   = raw_data.events{2}(starting_events + 3);
    weigh  = hd_extract_sequence(raw_data, param.raw_cols, t_starting_event, t_ending_event);
    
    % Rotate action
    t_starting_event = raw_data.events{2}(starting_events + 4);
    t_ending_event   = raw_data.events{2}(starting_events + 5);
    rotate = hd_extract_sequence(raw_data, param.raw_cols, t_starting_event, t_ending_event);

    labels = raw_data.labels{3};
    save([param.root, param.filenames.raw_actions], 'labels', 'grasp', 'weigh', 'rotate');
end

%% Analysis
if do_analyse == 1
    load([param.root, param.filenames.raw_actions]);
    [Y, objects] = labels_to_Y(labels);

    disp('-- Analysing data');

%     disp('-- Force/torque');
%     hde_force_torque;
%     save([param.root, 'matlab/hde_force_torque.mat'], 'Ypred', 'Ytest', 'confidence');

%     disp('-- Modalities');
%     hde_modalities;
%     save([param.root, 'matlab/hde_modalities.mat'], 'Ypred', 'Ytest', 'confidence');
    
%     disp('-- Confidence combination');
%     hde_confidence_combination;
%     save([param.root, 'matlab/hde_confidence_combination.mat'], 'Ytr', 'Ytr_pred1', 'Yva', 'Yva_pred1', 'Yva_pred2', 'Yte', 'Yte_pred1', 'Yte_pred2', 'confidence');

%     [Ypred, Ytest, confidence] = hde_moments;
%     hde_moments_res.Ypred = Ypred;
%     hde_moments_res.Ytest = Ytest;
%     hde_moments_res.conf= confidence;

end