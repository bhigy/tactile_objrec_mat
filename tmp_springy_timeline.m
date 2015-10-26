L = labels{3};

% bslopes = bslopes(1:142, :);
% X5 = bslopes(:,4) - bslopes(:,2);
% X6 = bslopes(:,3) - bslopes(:,1);
% X7 = X5 ./ X6;
% X = X7;
% L = L(1:142);
% nb_test = 6;

bslopes = bslopes(1:142, :);
X5 = bslopes(:,4) - bslopes(:,2);
X6 = bslopes(:,3) - bslopes(:,1);
X7 = X5 ./ X6;
X = [bslopes  X5 X6 X7]; 
L = L(1:142);
nb_test = 6;

% X = sampling;
% nb_test = 8;

% X = fft_data;
% nb_test = 8;

% X = P;
% nb_test = 8;

X = standardize_matrix(X);
Y = labels_to_Y(L);
S = BasicSupervisedDataset(X, Y);
nb_items = min(count_occurences(Y));
nb_iter = 20;
mean_accuracy_test = zeros(nb_iter, 1);

for i = 1:nb_iter
    [S, ~] = S.split(nb_items, Dataset.SPLITMODE_ABS);
    [test, training] = S.split(nb_test, Dataset.SPLITMODE_ABS);
    no_test = training.copy();

    [training, validation] = training.split(50, Dataset.SPLITMODE_PCT);

    k_values = 1:2:size(unique(training.X, 'rows'), 1);
    nb_trials = 100;
    accuracy = kmean_accuracy(training, validation, k_values, nb_trials);

    mean_accuracy = mean(accuracy, 2);
%     figure;
%     plot(k_values, mean_accuracy);
%     sd = std(accuracy, 0, 2);
%     errorbar(k_values, mean_accuracy, sd);

    max_mean_accuracy = max(mean_accuracy);
    best_k = find(mean_accuracy == max_mean_accuracy);
    [accuracy, best_model, Ypred, ~] = k_clusters_accuracy(no_test, test, best_k(1), nb_trials);
    mean_accuracy_test(i) = mean(accuracy, 1);
end