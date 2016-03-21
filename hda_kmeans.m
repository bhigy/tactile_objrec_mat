% Analyzing haptic data

%% Parameters
nb_trials = 100;
k_values  = 1:size(unique(training.X, 'rows'), 1);

%% Splitting the haptic data
S = BasicSupervisedDataset(X, Y);
N = min(countOccurences(Y));
S = S.split(N, Dataset.SPLITMODE_ABS);

% Splitting data into training, validation and test sets
[test, training] = S.split(param.nb_items_test, Dataset.SPLITMODE_ABS);
no_test = training.copy();
[training, validation] = training.split(50, Dataset.SPLITMODE_PCT);

%% Mean accuracy for several k
accuracy = kmean_accuracy(training, validation, k_values, nb_trials);

mean_accuracy = mean(accuracy, 2);
% figure;
% plot(k_values, mean_accuracy);
% sd = std(accuracy, 0, 2);
% errorbar(k_values, mean_accuracy, sd);

max_mean_accuracy = max(mean_accuracy);
best_k = find(mean_accuracy == max_mean_accuracy);
fprintf('Best mean accuracy: %f (k=%d)\n', max_mean_accuracy, best_k(1));
[accuracy, best_model, ~, ~] = k_clusters_accuracy(no_test, test, best_k(1), nb_trials);
mean_accuracy_test = mean(accuracy, 1);
fprintf('Mean accuracy achieved with test set for that k: %f\n', mean_accuracy_test);

% computing the predicted categories
% Ypred = predicted_cat(best_model, X, Y);

% %% Ploting the clusters
% % Dimension reduction - SVD
% svd_points = X.get_2D_projection(Dataset.METH_SVD);
% svd_points.draw(Y, labels);
% svd_points.draw(Ycomp, arrayfun(@(x) labels(x), most_freq));
% 
% % Dimension reduction - t_NSE
% tsne_points = X.get_2D_projection(Dataset.METH_TSNE);
% tsne_points.draw(Y, labels);
% tsne_points.draw(Ycomp', arrayfun(@(x) labels(x), most_freq));