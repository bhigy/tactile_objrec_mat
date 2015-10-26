function C = centralize_matrix(M)
    C = zeros(size(M, 1), size(M, 2));
    m = mean(M);
    for i = 1:size(C,1)
        C(i,:) = (M(i,:) - m);
    end
end