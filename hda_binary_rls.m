function [Ypred, Yte, confidence] = hda_binary_rls(Xsets, Y, nb_iter, nb_items_test)
%HDA_BINARY_RLS Train binary classifiers with RLS

    nb_sets = length(Xsets);
    nb_cats = length(unique(Y));
    Ypred = zeros(nb_sets, nb_iter, nb_items_test * nb_cats, nb_cats, nb_cats);
    Yte = zeros(nb_iter, nb_items_test * nb_cats);
    confidence = zeros(nb_sets, nb_iter, nb_items_test * nb_cats, nb_cats, nb_cats);

    for i_iter = 1:nb_iter
        sel = randSelCat(nb_items_test, Y);
        Ytr = Y(~sel);
        Yte(i_iter, :) = Y(sel)';
        for i_set = 1:nb_sets
            Xtr = Xsets{i_set}(~sel, :);
            Xte = Xsets{i_set}(sel, :);
            for i_item1 = 1:nb_cats
                for i_item2 = i_item1 + 1:nb_cats
                    Xtr_bin = Xtr(Ytr == i_item1 | Ytr == i_item2, :);
                    Ytr_bin = Ytr(Ytr == i_item1 | Ytr == i_item2, :);
                    model = gurls_train(Xtr_bin, Ytr_bin, struct('verbose', false));
                    scores = gurls_test(model, Xte);
                    confidence(i_set, i_iter, :, i_item1, i_item2) = scores;
                    confidence(i_set, i_iter, :, i_item2, i_item1) = -scores;
                    pred = score2pred(model, scores);
                    Ypred(i_set, i_iter, :, i_item1, i_item2) = pred;
                    Ypred(i_set, i_iter, :, i_item2, i_item1) = pred;
                end
            end
        end
    end 
end