function starting_events = getStartingEvents(data)

    [~, starting_events] = find_closest(data.labels{2}, data.events{2});
    % Sometimes, the label has the same timestamp as the give-ack
    wrong = strcmp(data.events{3}(starting_events), 'reply');
    starting_events(wrong) = starting_events(wrong) + 1;
end