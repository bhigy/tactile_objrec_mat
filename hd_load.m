function [data, labels] = hd_load(param)
%HD_LOAD Loading the data

    disp('--- Loading raw data');
    raw_data = param.loading_routine(param.root);
%     save([param.root, param.filenames.raw], '-v7.3', 'raw_data');
    
    disp('--- Filtering invalid trials');
    raw_data.labels = eraseCells(raw_data.labels, param.invalid_trials);

    disp('--- Extracting actions');
    starting_events = getStartingEvents(raw_data);
    
    % Grasp action
    t_starting_event = raw_data.events{2}(starting_events) + 0.01;
    t_ending_event   = raw_data.events{2}(starting_events + 2);
    data.grasp = hd_extract_sequence(raw_data, param.raw_cols, t_starting_event, t_ending_event);
    
    % Weigh action
    t_starting_event = raw_data.events{2}(starting_events + 2);
    t_ending_event   = raw_data.events{2}(starting_events + 3);
    data.weigh  = hd_extract_sequence(raw_data, param.raw_cols, t_starting_event, t_ending_event);
    
    % Rotate action
    t_starting_event = raw_data.events{2}(starting_events + 4);
    t_ending_event   = raw_data.events{2}(starting_events + 5);
    data.rotate = hd_extract_sequence(raw_data, param.raw_cols, t_starting_event, t_ending_event);

    labels = raw_data.labels{3};
end