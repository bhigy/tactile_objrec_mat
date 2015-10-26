function S = standardize_matrix(M)
    S = zeros(size(M, 1), size(M, 2));
    m = mean(M);
    s = std(M);
    s(s == 0) = 1; % avoid dividing by 0
    for i = 1:size(S,1)
        S(i,:) = (M(i,:) - m) ./ s;
    end
end