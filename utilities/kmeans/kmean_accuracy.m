function accuracy = kmean_accuracy(Str, Svl, k_range, nb_trials)
% Compute the accuracy over a range of values for k
%   Str (SupervisedDataset):        the training set 
%   Str (SupervisedDataset):        the validation set 
%   k_range (array of integers):    range of values for k
%   [nb_trials] (integer):          the number of trials for each k

    if ~exist('nb_trials', 'var') || isempty(nb_trials)
        nb_trials = 10;
    end

    accuracy = zeros(length(k_range), nb_trials);

    i = 1;
    for k = k_range
        disp(['k = ', num2str(k)]);
        [accuracy(i, :), ~] = k_clusters_accuracy(Str, Svl, k, nb_trials);
        i = i + 1;
    end
end