function F = hdf_fourier(data)

    nb_items = size(data, 1);
    max_length = 0;
    for i = 1:nb_items
        if length(data{i}) > max_length
            max_length = length(data{i});
        end
    end
    
    n = 2^nextpow2(max_length);
    F = zeros(nb_items, n * 2);

    for i = 1:nb_items
        complex = fft(data{i}, n);
        F(i, :) = [real(complex), imag(complex)];
    end
end