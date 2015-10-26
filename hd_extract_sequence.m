function event_data = hd_extract_sequence(data, raw_cols, start_offset, end_offset)
    % Selecting for each trial the lines corresponding to a sequence
    % (starting with an event and ending with an other one)

    [~, i_starting_lines] = find_closest(data.labels{2}, data.events{2});
    % Sometimes, the label has the same timestamp as the give-ack
    wrong = strcmp(data.events{3}(i_starting_lines), 'reply');
    i_starting_lines(wrong) = i_starting_lines(wrong) + 1;
    
    i_ending_lines = i_starting_lines + end_offset;
    i_starting_lines = i_starting_lines + start_offset;
    nb_trials = length(data.labels{2});
    
    event_data.analog      = cell(nb_trials, 1);
    event_data.skin        = cell(nb_trials, 1);
    event_data.skin_comp   = cell(nb_trials, 1);
    event_data.springy     = cell(nb_trials, 1);
    event_data.state       = cell(nb_trials, 1);
    event_data.wrench      = cell(nb_trials, 1);
    event_data.cart_wrench = cell(nb_trials, 1);
    
    t_starting_event = data.events{2}(i_starting_lines);
    t_ending_event   = data.events{2}(i_ending_lines);
    event_data.t_start = t_starting_event;
    event_data.t_end   = t_ending_event;
    
    for trial = 1:nb_trials
        lines = find_between(t_starting_event(trial), t_ending_event(trial), data.analog(:, 2));
        event_data.analog{trial} = data.analog(lines, raw_cols.analog);
        
        lines = find_between(t_starting_event(trial), t_ending_event(trial), data.skin(:, 2));
        event_data.skin{trial} = data.skin(lines, raw_cols.skin);
        
        lines = find_between(t_starting_event(trial), t_ending_event(trial), data.skin_comp(:, 2));
        event_data.skin_comp{trial} = data.skin_comp(lines, raw_cols.skin);
        
        lines = find_between(t_starting_event(trial), t_ending_event(trial), data.springy(:, 2));
        event_data.springy{trial} = data.springy(lines, raw_cols.springy);
        
        lines = find_between(t_starting_event(trial), t_ending_event(trial), data.state(:, 2));
        event_data.state{trial} = data.state(lines, raw_cols.state);
        
        lines = find_between(t_starting_event(trial), t_ending_event(trial), data.wrench(:, 2));
        event_data.wrench{trial} = data.wrench(lines, raw_cols.wrench);
        
        lines = find_between(t_starting_event(trial), t_ending_event(trial), data.cart_wrench(:, 2));
        event_data.cart_wrench{trial} = data.cart_wrench(lines, raw_cols.cart_wrench);
    end
end