function [freq, power] = fft2pow(F)
    fs = 100;
    n = size(F, 1);         % Transform length
    freq = (0:n-1)*(fs/n);  % Frequency range
    power = F.*conj(F)/n;   % Power of the DFT
end