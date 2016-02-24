function [Ytr, Ytr_pred1, Yva, Yva_pred1, Yva_pred2, Yte, Yte_pred1, Yte_pred2, confidence] = hda_hierarchical_rls_with_val(Xsets, Y, nb_iter, nb_items_val, nb_items_test)

    % TODO : gérer une matrice pour Xsets
    
    nb_sets = length(Xsets);
    nb_cats = length(unique(Y));
    nb_items = size(Xsets{1}, 1);
    Yte_pred2 = cell(1);
    Yva_pred2 = cell(1);
    Yte = cell(1);
    confidence = cell(1, nb_iter);
    Ytr_pred1 = cell(nb_sets, 1);
    Yva_pred1 = cell(nb_sets, 1);
    Yte_pred1 = cell(nb_sets, 1);
    nb_items_tr_tot = nb_items - ((nb_items_val + nb_items_test) * nb_cats);
    
    for i = 1:nb_sets
        Ytr_pred1{i} = zeros(nb_iter, nb_items_tr_tot);
        Yva_pred1{i} = zeros(nb_iter, nb_items_val * nb_cats);
        Yte_pred1{i} = zeros(nb_iter, nb_items_test * nb_cats);
    end
    
    Yte_pred2{1} = zeros(nb_iter, nb_items_test * nb_cats);
    Yva_pred2{1} = zeros(nb_iter, nb_items_val * nb_cats);
    Yte{1}   = zeros(nb_iter, nb_items_test * nb_cats);

    for i = 1:nb_iter
        sel_te = randSelCat(nb_items_test, Y);
        Yremaining = Y(~sel_te);
        sel_va = randSelCat(nb_items_val, Yremaining);
        Xtr_hier = zeros(nb_items_tr_tot, nb_cats * nb_sets);
        Xva_hier = zeros(nb_items_val * nb_cats, nb_cats * nb_sets);
        Xte_hier = zeros(nb_items_test * nb_cats, nb_cats * nb_sets);
        first = 1;
        for j = 1:nb_sets
            Xte = Xsets{j}(sel_te, :);
            Yte{1}(i, :) = Y(sel_te)';
            Xremaining = Xsets{j}(~sel_te, :);
            Xva = Xremaining(sel_va, :);
            Yva = Yremaining(sel_va);
            Xtr = Xremaining(~sel_va, :);
            Ytr = Yremaining(~sel_va);
            last = first + nb_cats - 1;
            
            [~, model] = evalc('gurls_train(Xtr, Ytr)');
            [~, Ytr_pred1{j}(i, :)] = evalc('gurls_test(model, Xtr)');
            Xtr_hier(:, first:last) = model.pred;
            [~, Yva_pred1{j}(i, :)] = evalc('gurls_test(model, Xva)');
            Xva_hier(:, first:last) = model.pred;
            [~, Yte_pred1{j}(i, :)] = evalc('gurls_test(model, Xte)');
            Xte_hier(:, first:last) = model.pred;
            
            first = first + nb_cats;
        end
        [~, model] = evalc('gurls_train(Xva_hier, Yva)');
        [~, Yva_pred2{1}(i, :)] = evalc('gurls_test(model, Xva_hier)');
        [~, Yte_pred2{1}(i, :)] = evalc('gurls_test(model, Xte_hier)');
        confidence{1, i} = model.pred;
    end 
end