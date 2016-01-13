function seq_data = hd_extract_sequence(data, raw_cols, t_starting_event, t_ending_event)
    % Selecting for each trial the lines corresponding to a sequence
    % (between to timestamps)

    nb_trials = length(data.labels{2});
    
    seq_data.analog      = cell(nb_trials, 1);
    seq_data.skin        = cell(nb_trials, 1);
    seq_data.skin_comp   = cell(nb_trials, 1);
    seq_data.springy     = cell(nb_trials, 1);
    seq_data.state       = cell(nb_trials, 1);
    seq_data.wrench      = cell(nb_trials, 1);
    seq_data.cart_wrench = cell(nb_trials, 1);
    seq_data.t_start     = t_starting_event;
    seq_data.t_end       = t_ending_event;
    
    % List of modalities we want to go through
    fields = {'analog', 'skin', 'skin_comp', 'springy', 'state', 'wrench', 'cart_wrench'};

    for i=1:numel(fields)
        if ~isempty(data.(fields{i}))
            start = 1;
            for trial = 1:nb_trials
                % We start looking from where we stopped previously
                lines = find_between(t_starting_event(trial), t_ending_event(trial), data.(fields{i})(start:end, 2));
                % We correct the index
                lines = lines + start - 1;
                seq_data.(fields{i}){trial} = data.(fields{i})(lines, raw_cols.(fields{i}));
                start = lines(end) + 1;
            end
        end
    end
end