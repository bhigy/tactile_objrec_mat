function [Ypred, Yte, confidence] = hda_rls(Xsets, Y, nb_iter, nb_items_test)
%HDA_RLS Trains multi-class classifiers with RLS

    % TODO : gérer une matrice pour Xsets
    
    nb_sets = length(Xsets);
    nb_cats = length(unique(Y));
    Ypred = cell(nb_sets, 1);
    Yte = cell(nb_sets, 1);
    confidence = cell(nb_sets, nb_iter);
    
    for i = 1:nb_sets
        Ypred{i} = zeros(nb_iter, nb_items_test * nb_cats);
        Yte{i} = zeros(nb_iter, nb_items_test * nb_cats);
    end

    for i = 1:nb_iter
        sel = randSelCat(nb_items_test, Y);
        for j = 1:nb_sets
            Xtr = Xsets{j}(~sel, :);
            Ytr = Y(~sel);
            Xte = Xsets{j}(sel, :);
            Yte{j}(i, :) = Y(sel)';
            model = gurls_train(Xtr, Ytr, struct('verbose', false));
            scores = gurls_test(model, Xte);
            confidence{j, i} = scores;
            Ypred{j}(i, :) = score2pred(model, scores);
        end
    end 
end