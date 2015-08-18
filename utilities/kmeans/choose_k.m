function [k, accuracy, model] = choose_k(Str, Svl, nb_trials, impr_min, impr_step)
% Select the best value for k, i.e. the one after which we don't have
% any improvement
%   Str (SupervisedDataset):    the training set 
%   Str (SupervisedDataset):    the validation set 
%   [nb_trials] (integer):      the number of trials for each k
%   impr_min (decimal):         the minimal improvement we allow
%   impr_step (integer):        the number of steps the improvement should be
%                               below impMin before we stop

    if ~exist('nb_trials', 'var') || isempty(nb_trials)
        nb_trials = 10;
    end

    k = 0;
    nbSteps = 0;
    accuracy = 0;
    while nbSteps < impr_step
        k = k + 1;
        [accuracy, best_model] = k_clusters_accuracy(Str, Svl, k, nb_trials);
        
        % Checking the improvement
        mean_accuracy = mean(accuracy);
        disp(['k = ', num2str(k), ' - mean score = ', num2str(mean_accuracy * 100), '%']);
        if (mean_accuracy - accuracy) / accuracy * 100 >= impr_min
            nbSteps = 0;
            accuracy = mean_accuracy;
            model = best_model;
        else
            nbSteps = nbSteps + 1;
        end
    end
    k = k - impr_step;
end