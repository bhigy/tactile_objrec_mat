% Analyzing haptic data

%% Parameters
nb_trials = 1000;
k_values  = 1:24;


%% Loading data
load([root, filtered_filename]);


%% Mean accuracy for several k
accuracy = kmean_accuracy(training, validation, k_values, nb_trials);

mean_accuracy = mean(accuracy, 2);
% figure;
% plot(k_values, mean_accuracy);
% sd = std(accuracy, 0, 2);
% errorbar(k_values, mean_accuracy, sd);

max_mean_accuracy = max(mean_accuracy);
best_k = find(mean_accuracy == max_mean_accuracy);
fprintf('Best mean accuracy: %f (k=%d)\n', max_mean_accuracy, best_k);
[accuracy, best_model, ~, Ypred] = k_clusters_accuracy(no_test, test, best_k, nb_trials);
mean_accuracy_test = mean(accuracy, 1);
fprintf('Mean accuracy achieved with test set for that k: %f\n', mean_accuracy_test);