nb_iter = 10;
fields = {'analog', 'wrench', 'cart_wrench'};

X = cell(length(fields) * 3, 1);

i = 1;
for i_mod = 1:numel(fields)
    if ~isempty(grasp.(fields{i_mod}))
        cols = 2:size(grasp.(fields{i_mod}){1}, 2);
        X{i} = hdf_fourier(hd_extract_col(grasp.(fields{i_mod}), cols));
        i = i + 1;
    end
    if ~isempty(weigh.(fields{i_mod}))
        cols = 2:size(weigh.(fields{i_mod}){1}, 2);
        X{i} = hdf_fourier(hd_extract_col(weigh.(fields{i_mod}), cols));
        i = i + 1;
    end
    if ~isempty(rotate.(fields{i_mod}))
        cols = 2:size(rotate.(fields{i_mod}){1}, 2);
        X{i} = hdf_fourier(hd_extract_col(rotate.(fields{i_mod}), cols));
        i = i + 1;
    end
end

[Ypred, Ytest, confidence] = hda_rls(X, Y, nb_iter, param.nb_items_test);