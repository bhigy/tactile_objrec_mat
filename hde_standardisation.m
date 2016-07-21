%HDE_STANDARDISATION

Xstd = cell(size(X));

for i_cond = 1:length(X)
    cols = 2:size(grasp.(fields{i_cond}){1}, 2);
    Xstd{i_cond} = standardise(X{i_cond});
end

[Ypred, Ytest, confidence] = hda_rls(Xstd, Y, nb_iter, param.nb_items_test);