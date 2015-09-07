function lines = find_between(min, max, target)
% Find all lines in target between min and max values
% target values are supposed to be sorted in increasing order
    
    if isempty(target)
        lines = [];
        return;
    end
    
    iTarget = 1;
    while iTarget <= length(target) && target(iTarget) < min
        iTarget = iTarget + 1;
    end
    if iTarget > length(target)
        % all values below min
        lines = [];
        return;
    end
    
    first = iTarget;
    while iTarget <= length(target) && target(iTarget) <= max
        iTarget = iTarget + 1;
    end
    last = iTarget - 1;
    
    if last <= first
        lines = [];
    else
        lines = first:last;
    end
end



