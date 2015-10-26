function S = smooth(M, times)
    if ~exist('times', 'var') || isempty(times)
        times = 1;
    end
       
    alpha = 1/3;
    S = M;
    for i = 1:times
        S(2:end-1) = alpha*S(2:end-1) + (1-alpha)*0.5*(S(1:end-2)+S(3:end));
    end
end