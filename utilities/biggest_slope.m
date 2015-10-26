function [slope_start_x, slope_start_y, slope_end_x, slope_end_y] = biggest_slope(M, min_slope)
% TODO 
% renvoyer la hauteur + la pente (hauteur / longueur)
    if ~exist('min_slope', 'var') || isempty(min_slope)
        min_slope = 0;
    end
    
    delta = M(2:end) - M(1:end-1);
    slope_start_x = 0;
    slope_start_y = 0;
    slope_end_x = 0;
    slope_end_y = 0;
    s = 0;
    for i = 1:length(delta)
        if delta(i) >= min_slope
            if s == 0
                s = i;
            end
        else
            if s ~= 0
                e = i;
                if M(e) - M(s) > slope_end_y - slope_start_y;
                    slope_start_x = s;
                    slope_start_y = M(s);
                    slope_end_x = e;
                    slope_end_y = M(e);
                end
                s = 0;
            end
        end
    end
    
    if s ~= 0
        e = length(delta);
        if M(e) - M(s) > slope_end_y - slope_start_y;
            slope_start_x = s;
            slope_start_y = M(s);
            slope_end_x = e;
            slope_end_y = M(e);
        end
    end
end