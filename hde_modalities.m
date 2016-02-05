nb_iter = 10;
t_snapshot = grasp.t_end - param.grasp_duration / 2;

% fields = {'analog', 'skin', 'skin_comp', 'springy', 'state', 'wrench', 'cart_wrench'};
fields = {'analog', 'springy', 'state', 'wrench', 'cart_wrench'};

X = cell(length(fields) * 3 + 3, 1);

i = 1;
for i_mod = 1:numel(fields)
    if ~isempty(grasp.(fields{i_mod}))
        cols = 2:size(grasp.(fields{i_mod}){1}, 2);
        % ???
        if strcmp(fields{i_mod}, 'springy')
            cols = 2:size(grasp.(fields{i_mod}){1}, 2); 
        elseif strcmp(fields{i_mod}, 'state')
            cols = 2:size(grasp.(fields{i_mod}){1}, 2);
        end
        X{i} = hdf_snapshot(grasp.(fields{i_mod}), t_snapshot, cols);
        X{i + 1} = hdf_fourier(hd_extract_col(grasp.(fields{i_mod}), cols));
        X{i + 2} = [X{i}, X{i + 1}];
        X{length(X) - 2} = [X{length(X)}, X{i}];
        X{length(X) - 1} = [X{length(X)}, X{i + 1}];
        X{length(X)} = [X{length(X)}, X{i + 2}];
        i = i + 3;
    end
end

[Ypred, Ytest, confidence] = hda_rls(X, Y, nb_iter, param.nb_items_test);