nb_iter = 10;
t_snapshot = grasp.t_end - param.grasp_duration / 2;

% fields = {'analog', 'skin', 'skin_comp', 'springy', 'state', 'wrench', 'cart_wrench'};
fields = {'analog', 'springy', 'state', 'wrench', 'cart_wrench'};

X = cell(length(fields) * 2 + 1, 1);

i = 1;
for i_mod = 1:numel(fields)
    if ~isempty(grasp.(fields{i_mod}))
        cols = 2:size(grasp.(fields{i_mod}){1}, 2);
        X{i} = hdf_snapshot(grasp.(fields{i_mod}), t_snapshot, cols);
        X{i + 1} = standardise(X{i});
        X{i + 2} = hdf_fourier(hd_extract_col(grasp.(fields{i_mod}), cols));
        X{i + 3} = standardise(X{i});
        i = i + 4;
    end
end
X{i} = [X{2:2:numel(fields) * 2}];
% X{i + 1} = [X{[2, 6, 8]}];
% X{i + 2} = [X{6:8}];

[Ypred, Ytest, confidence] = hda_rls(X, Y, nb_iter, param.nb_items_test);