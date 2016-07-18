function P = pairwise_coupling(r, n, conv_crit)
%PAIRWISE_COUPLING Coupling of pairwise classifiers predictions (see
% Hastie & Tibshirani, 1998)
%
% IN
%   r:        Matrix of pairwise probabilities
%   n:        (Optional) ???
%   convCrit: (Optional) Convergence criterion
% OUT
%   P:        Probability of each class

if ~exist('n', 'var') || isempty(n)
    n = ones(size(r));
end

if ~exist('convCrit', 'var') || isempty(conv_crit)
    conv_crit = 0.01;
end

K = size(r, 1);

P = 2 / K * sum(r, 2) / (K - 1);
mu = repmat(P, 1, K);
mu = mu ./ (mu + mu');
mu = mu - eye(size(mu)) .* mu;

improvement = true;
while improvement
    P_old = P;
    P = P .* sum(n.*r, 2) ./ sum(n.*mu, 2);
    P = P / sum(P);
    mu = repmat(P, 1, K);
    mu = mu ./ (mu + mu');
    mu = mu - eye(size(mu)) .* mu;
    
    improvement =  norm(P_old - P) >= conv_crit;
end

end