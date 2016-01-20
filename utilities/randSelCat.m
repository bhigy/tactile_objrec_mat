function selection = randSelCat(m, grouping)
    % Returns a vector of the same size as grouping, with m '1' choosen randomly 
    % for each category (defined by grouping) and everything else being '0'
    
    len = length(grouping);
    if (m > length(grouping))
        error('Invalid arguments (m > length(grouping))'); 
    end
    
    selection = zeros(len, 1);
    
    categories = unique(grouping);
    for i_cat = 1:length(categories)
        i_members = find(grouping == categories(i_cat));
        len_cat = length(i_members);
        
        for j = len_cat:-1:(len_cat - m + 1)
            r = ceil(rand()*j);
            selection(i_members(r)) = 1;
            i_members(r) = [];
        end
    end
    
    selection = logical(selection);
end