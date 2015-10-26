% Analyzing kmeans stability depending on the number of trials

%% Loading data
load([root, filtered_filename]);

%% Parameters
k_values  = 1:size(unique(training.X, 'rows'), 1);
nb_trials_range = [1 2 3 4 5 6 7 8 9 10 20 30 40 50 60 70 80 90 100 200 300 400 500 600 700 800 900 1000];
Mtr = zeros(length(nb_trials_range), 1);
SDtr = zeros(length(nb_trials_range), 1);
Mte = zeros(length(nb_trials_range), 1);
SDte = zeros(length(nb_trials_range), 1);
i = 0;

for nb_trials = nb_trials_range;
    i = i + 1;
    fprintf('Nb trials: %d\n', nb_trials);
    
    % Selecting k
    accuracy = kmean_accuracy(training, validation, k_values, nb_trials);
    mean_accuracy = mean(accuracy, 2);
    max_mean_accuracy = max(mean_accuracy);
    best_k = find(mean_accuracy == max_mean_accuracy);
    Mtr(i) = max_mean_accuracy;
    SDtr(i) = std(accuracy(best_k(1), :));
    
    % Testing
    fprintf('Best mean accuracy: %f (k=%d)\n', max_mean_accuracy, best_k(1));
    [accuracy, best_model, ~, Ypred] = k_clusters_accuracy(no_test, test, best_k(1), nb_trials);
    mean_accuracy_test = mean(accuracy, 1);
    Mte(i) = mean_accuracy_test;
    SDte(i) = std(accuracy);
    fprintf('Mean accuracy achieved with test set for that k: %f\n', mean_accuracy_test);
end

figure;
hold on;
errorbar(nb_trials_range, Mtr, SDtr);
errorbar(nb_trials_range, Mte, SDte);