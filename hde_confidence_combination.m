nb_iter = 10;
t_snapshot = grasp.t_end - param.grasp_duration / 2;

% fields = {'analog', 'skin', 'skin_comp', 'springy', 'state', 'wrench', 'cart_wrench'};
fields = {'analog', 'springy', 'state', 'wrench', 'cart_wrench'};
% fields = {'state', 'cart_wrench'};

X = cell(length(fields) * 2, 1);

i = 1;
for i_mod = 1:numel(fields)
    if ~isempty(grasp.(fields{i_mod}))
        cols = 2:size(grasp.(fields{i_mod}){1}, 2);
        if strcmp(fields{i_mod}, 'springy')
            cols = 2:size(grasp.(fields{i_mod}){1}, 2); 
        elseif strcmp(fields{i_mod}, 'state')
            cols = 2:size(grasp.(fields{i_mod}){1}, 2);
        end
        X{i} = hdf_snapshot(grasp.(fields{i_mod}), t_snapshot, cols);
        X{i + 1} = hdf_fourier(hd_extract_col(grasp.(fields{i_mod}), cols));
        i = i + 2;
    end
end

[Ytr, Ytr_pred1, Ytr_pred2, Yte, Yte_pred1, Yte_pred2, confidence] = hda_hierarchical_rls(X, Y, nb_iter, param.nb_items_test);
% [Ytr, Ytr_pred1, Yva, Yva_pred1, Yva_pred2, Yte, Yte_pred1, Yte_pred2, confidence] = hda_hierarchical_rls_with_val(X, Y, nb_iter, 10, param.nb_items_test);