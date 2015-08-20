function accuracy = kmean_accuracy(Str, Svl, k_range, nb_trials, display)
% Compute the accuracy over a range of values for k
%   Str (SupervisedDataset):        the training set 
%   Str (SupervisedDataset):        the validation set 
%   k_range (array of integers):    range of values for k
%   [nb_trials] (integer):          the number of trials for each k
%   display (bool):                 display processing details

    if ~exist('nb_trials', 'var') || isempty(nb_trials)
        nb_trials = 10;
    end
    
    if ~exist('display', 'var') || isempty(display)
        display = 0;
    end

    accuracy = zeros(length(k_range), nb_trials);

    i = 1;
    for k = k_range
        if display == 1
            disp(['k = ', num2str(k)]);
        end
        [accuracy(i, :), ~] = k_clusters_accuracy(Str, Svl, k, nb_trials);
        i = i + 1;
    end
end