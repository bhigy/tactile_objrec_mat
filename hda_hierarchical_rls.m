function [Ytr, Ytr_pred1, Ytr_pred2, Yte, Yte_pred1, Yte_pred2, confidence] = hda_hierarchical_rls(Xsets, Y, nb_iter, nb_items_test)
%HDA_HIERARCHICAL_RLS Trains two levels of classifiers with RLS

    % TODO : gérer une matrice pour Xsets
    % TODO : use two step of hda_rls instead
    
    nb_sets = length(Xsets);
    nb_cats = length(unique(Y));
    nb_items = size(Xsets{1}, 1);
    Yte_pred2 = cell(1);
    Yte = cell(1);
    confidence = cell(1, nb_iter);
    Ytr_pred1 = cell(nb_sets, 1);
    Yte_pred1 = cell(nb_sets, 1);
    nb_items_tr_tot = nb_items - nb_items_test * nb_cats;
    
    for i = 1:nb_sets
        Ytr_pred1{i} = zeros(nb_iter, nb_items_tr_tot);
        Yte_pred1{i} = zeros(nb_iter, nb_items_test * nb_cats);
    end
    
    Yte_pred2{1} = zeros(nb_iter, nb_items_test * nb_cats);
    Yte{1}   = zeros(nb_iter, nb_items_test * nb_cats);

    for i = 1:nb_iter
        sel_te = randSelCat(nb_items_test, Y);
        Yremaining = Y(~sel_te);
        Xtr_hier = zeros(nb_items_tr_tot, nb_cats * nb_sets);
        Xte_hier = zeros(nb_items_test * nb_cats, nb_cats * nb_sets);
        first = 1;
        for j = 1:nb_sets
            Xte = Xsets{j}(sel_te, :);
            Yte{1}(i, :) = Y(sel_te)';
            Xtr = Xsets{j}(~sel_te, :);
            Ytr = Y(~sel_te);
            last = first + nb_cats - 1;
            
%             [~, model] = evalc('gurls_train(Xtr, Ytr)');
            model = gurls_train(Xtr, Ytr, struct('verbose', false));
%             [~, Ytr_pred1{j}(i, :)] = evalc('gurls_test(model, Xtr)');
%             Xtr_hier(:, first:last) = model.pred;
            scores = gurls_test(model, Xtr);
            Xtr_hier(:, first:last) = scores;
            Ytr_pred1{j}(i, :) = score2pred(model, scores);
%             [~, Yte_pred1{j}(i, :)] = evalc('gurls_test(model, Xte)');
%             Xte_hier(:, first:last) = model.pred;
            scores = gurls_test(model, Xte);
            Xte_hier(:, first:last) = scores;
            Yte_pred1{j}(i, :) = score2pred(model, scores);

            first = first + nb_cats;
        end
%         [~, model] = evalc('gurls_train(Xtr_hier, Ytr)');
        model = gurls_train(Xtr_hier, Ytr, struct('verbose', false));
%         [~, Ytr_pred2{1}(i, :)] = evalc('gurls_test(model, Xtr_hier)');
        scores = gurls_test(model, Xtr_hier);
        Ytr_pred2{1}(i, :) = score2pred(model, scores);
%         [~, Yte_pred2{1}(i, :)] = evalc('gurls_test(model, Xte_hier)');
%         confidence{1, i} = model.pred;
        scores = gurls_test(model, Xte_hier);
        confidence{1, i} = scores;
        Yte_pred2{1}(i, :) = score2pred(model, scores);
    end 
end