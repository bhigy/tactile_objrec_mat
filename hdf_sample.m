function S = hdf_sample(data, nb_samples)
    
    nb_items = size(data, 1);
    nb_series = size(data{1}, 1);
    S = zeros(nb_items, nb_samples * nb_series);

    for trial = 1:nb_items
        first = 1;
        for line = 1:size(data{trial}, 1)
            step = (length(data{trial}(line, :)) - 1) / (nb_samples - 1);
            for i_sample = 0:nb_samples - 1
                i_data = 1 + round((i_sample) * step);
                S(trial, first + i_sample) = data{trial}(line, i_data);
            end
            first = first + nb_samples;
        end
    end
    
end