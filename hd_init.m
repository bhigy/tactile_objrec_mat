% Initializing some global parameters

% Filenames
raw_filename        = 'raw_data.mat';        % raw data filename
formalized_filename = 'formalized_data.mat'; % formalized data filename
splitted_filename   = 'splitted_data.mat';   % splitted data filename
filtered_filename   = 'filtered_data.mat';   % filtered data filename

% Columns for merged data
cols_analog    = 1:3;
cols_skin      = 4:107;
cols_skin_comp = 108:211;
cols_springy   = 212:216;
cols_state     = 217:224;

switch(set)
    case SET_PRETEST
        root           = '/home/bhigy/experiments/haptic_data_pretest/';    % root folder
        invalid_trials = 30;                                                % invalid trials to remove
        
    case SET_HAPTIC1
        root           = '/home/bhigy/experiments/haptic_data/';    % root folder
        invalid_trials = [25 62 75 114 149 150 202];                    % invalid trials to remove
end