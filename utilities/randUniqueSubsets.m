function S = randUniqueSubsets(X, k, nb_sub)
% Select random unique subsets of values from a vector
%
% X:        vector of values to choose from
% k:        size of the subsets
% nb_sub:  number of subsets to collect

    nb_comb = nchoosek(length(X), k);
    if nb_sub >  nb_comb
        error('Impossible to find %d different subsets from %d elements', nb_sub, length(X));
    end
    
    all = nchoosek(X, k);
    sel = randSel(nb_sub, nb_comb);
    S = all(sel, :);
end