function O = rand_order(labels, times)
    nb_items = length(labels);
    items = 1:nb_items;
    I = zeros(nb_items * times, 1);
    for i = 1:nb_items:nb_items * times
        j = i + nb_items - 1;
        I(i:j, 1) = items;
    end
    I = I(randperm(length(I)));
    O = cell(nb_items * times);
    for i = 1:length(labels)
        O(I==i) = labels(i);
    end
end