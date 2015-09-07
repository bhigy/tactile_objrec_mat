function [values, indexes] = find_closest(source, target)
% Foreach value in source, find the closest value in target
% source and target values are supposed to be sorted in increasing order
    
    iTarget = 1;
    values = zeros(length(source), 1);
    indexes = zeros(length(source), 1);
    for iSource = 1:length(source)
        while(iTarget <= length(target) && target(iTarget) < source(iSource))
            iTarget = iTarget + 1;
        end
        if(iTarget == 1 || (iTarget <= length(target) && abs(target(iTarget) - source(iSource)) < abs(target(iTarget - 1) - source(iSource))))
            values(iSource) = target(iTarget);
            indexes(iSource) = iTarget;
        else
            values(iSource) = target(iTarget - 1);
            indexes(iSource) = iTarget - 1;
        end
    end

end

