function [Xsub, Ysub] = hd_subsample(X, Y, nb_cats, nb_items)
%HD_SUBSAMPLE Subsample X and Y

if ~exist('nb_items', 'var') || isempty(nb_items)
    nb_items = -1;
end

Xsub = cell(size(X));
if nb_items ~= -1
    selection = zeros(nb_cats * nb_items, 1);
    first = 1;
    last = nb_items;
    for i_cat = 1:nb_cats
        selection(first:last, 1) = find(Y == i_cat, nb_items);
        first = last + 1;
        last = last + nb_items;
    end
else
    selection = ismember(Y, 1:nb_cats);
end



for i_set = 1:length(X)
    Xsub{i_set} = X{i_set}(selection, :);
end
Ysub = Y(selection);

end