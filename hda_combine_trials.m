function [Ysub, Ypred] = hda_combine_trials(Y, confidence, k, nb_sub)
% Combine the confidence from several trials to predicte the category
%
% IN
% Y:            true catgory of each trial
% confidence    confidence for each trial to belong to each category
% k             number of trials to combine
% nb_sub        nb of subet to make; if not defined, try all combinations
%
% OUT
% Ysub:         true category of the subset
% Ypred:        predicted category for the subset

    nb_trials = size(Y, 1);
    nb_cat = length(unique(Y));
    nb_comb = nchoosek(nb_trials / nb_cat, k);
    
    if ~exist('nb_sub', 'var') || isempty(nb_sub)
        nb_sub = -1;
    end
    
    Ysub = zeros(nb_comb * nb_cat, 1);
    Ypred = zeros(nb_comb * nb_cat, 1);

    i_Y = 1;
    for cat = 1:nb_cat
        items = find(Y == cat);
        subsets = nchoosek(items, k);
        if nb_sub >= 0
            subset = subset(randSel(nb_sub, nb_comb));
        end
        for i_sub = 1:size(subsets, 1)
            Ysub(i_Y) = cat;
            conf = sum(confidence(subsets(i_sub, :), :));
            [~, Ypred(i_Y)] = max(conf);
            i_Y = i_Y + 1;
        end
    end
    
end