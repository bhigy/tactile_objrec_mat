function F = hdf_fourier(data)
%HDF_FOURIER

    % Computing the max size (not all series may have the same size)
    nb_lines = size(data, 1);
    nb_series = size(data{1}, 1);
    max_length = 0;
    for i = 1:nb_lines
        if size(data{i}, 2) > max_length
            max_length = size(data{i}, 2);
        end
    end
    
    len = 2.^nextpow2(max_length);
    F = zeros(nb_lines, len * 2 * nb_series);

    % Computing fft
    for i = 1:nb_lines
        next = 1;
        % If we have several raw in each cell, we concatenate the results
        for j= 1:nb_series
            complex = fft(data{i}(j, :), len);
            last = next + len * 2 - 1;
            F(i, next:last) = [real(complex), imag(complex)];
            next = next + len * 2;
        end
    end
end