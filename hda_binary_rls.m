function [Ypred, Yte_bin, confidence] = hda_binary_rls(Xsets, Y, nb_iter, nb_items_test)
%HDA_BINARY_RLS Train binary classifiers with RLS

    % TODO : gérer une matrice pour Xsets
    
    nb_sets = length(Xsets);
    nb_cats = length(unique(Y));
    nb_pairs = nb_cats * (nb_cats - 1) / 2;
    Ypred = cell(nb_sets, nb_pairs);
    Yte_bin = cell(nb_sets, nb_pairs);
    confidence = cell(nb_sets, nb_pairs, nb_iter);
    
    for i_sets = 1:nb_sets
        for i_pair = 1:nb_pairs
            Ypred{i_sets, i_pair} = zeros(nb_iter, nb_items_test * 2);
            Yte_bin{i_sets, i_pair} = zeros(nb_iter, nb_items_test * 2);
        end
    end

    for i_iter = 1:nb_iter
        sel = randSelCat(nb_items_test, Y);
        Ytr = Y(~sel);
        for i_set = 1:nb_sets
            Xtr = Xsets{i_set}(~sel, :);
            Xte = Xsets{i_set}(sel, :);
            Yte = Y(sel)';
            i_pair = 1;
            for i_item1 = 1:nb_cats
                for i_item2 = i_item1 + 1:nb_cats
                    Xtr_bin = Xtr(Ytr == i_item1 | Ytr == i_item2, :);
                    Ytr_bin = Ytr(Ytr == i_item1 | Ytr == i_item2, :);
                    Xte_bin = Xte(Yte == i_item1 | Yte == i_item2, :);
                    Yte_bin{i_set, i_pair}(i_iter, :) = Yte(Yte == i_item1 | Yte == i_item2);
                    model = gurls_train(Xtr_bin, Ytr_bin, struct('verbose', false));
                    scores = gurls_test(model, Xte_bin);
                    confidence{i_set, i_pair, i_iter} = scores;
                    Ypred{i_set, i_pair}(i_iter, :) = score2pred(model, scores);
                    i_pair = i_pair + 1;
                end
            end
        end
    end 
end