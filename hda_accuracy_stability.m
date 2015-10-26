% Main script controlling the overall pipeline
addpath(genpath('/home/bhigy/dev/tactile_objrec_mat'));
init;

load([root, formalized_filename]);
Sorigin = BasicSupervisedDataset(X, Y);

%% Size of training set

n_range = 2:2:20;
accuracy_training = zeros(length(n_range), 10);
accuracy_test     = zeros(length(n_range), 10);
i = 0;

for n = n_range
    fprintf('## Number of items: %d\n', n);
    i = i + 1;
    for j = 1:10
        fprintf('# Trial: %d\n', j);
        S = Sorigin.copy();
        [test, training] = S.split(6, Dataset.SPLITMODE_ABS);
        [training, ~] = training.split(n, Dataset.SPLITMODE_ABS);
        no_test = training.copy();
        [training, validation] = training.split(50, Dataset.SPLITMODE_PCT);

        % Saving data
        save([root, splitted_filename], 'S', 'no_test', 'training', 'validation', 'test', 'objects');

        use_finger = [1 1 1 1];
        use_data   = [1 0 0 1 1];
        standardize = 1;
        hd_prepare;

        hd_analyze_accuracy;

        accuracy_training(i,j) = max_mean_accuracy;
        accuracy_test(i,j)     = mean_accuracy_test;
    end
end

Mtr = mean(accuracy_training, 2);
SDtr = std(accuracy_training, 0, 2);
Mte = mean(accuracy_test, 2);
SDte = std(accuracy_test, 0, 2);

figure;
hold on;
errorbar(n_range, Mtr, SDtr);
errorbar(n_range, Mte, SDte);
legend('Validation', 'Test');
hold off;

%% Size of test set

n_range = 1:10;
accuracy_test2 = zeros(length(n_range), 10);

for j = 1:10
    fprintf('## Trial: %d\n', j);
    i = 0;
    S = Sorigin.copy();
    [test, training] = S.split(10, Dataset.SPLITMODE_ABS);
    [training, ~] = training.split(16, Dataset.SPLITMODE_ABS);
    no_test = training.copy();
    [training, validation] = training.split(50, Dataset.SPLITMODE_PCT);

    % Saving data
    save([root, splitted_filename], 'S', 'no_test', 'training', 'validation', 'test', 'objects');

    % Preparing data
    use_finger = [1 1 1 1];
    use_data   = [1 0 0 1 1];
    standardize = 1;
    hd_prepare;

    % Finding the model
    load([root, filtered_filename]);
    nb_trials = 100;
    k_values  = 1:size(unique(training.X, 'rows'), 1);
    accuracy = kmean_accuracy(training, validation, k_values, nb_trials);
    mean_accuracy = mean(accuracy, 2);
    max_mean_accuracy = max(mean_accuracy);
    best_k = find(mean_accuracy == max_mean_accuracy);
    fprintf('Best mean accuracy: %f (k=%d)\n', max_mean_accuracy, best_k(1));
    
    % Testing increasing size for the test set
    for n = n_range
        fprintf('# Number of items: %d\n', n);
        i = i + 1;
        
        [test_n, ~] = test.split(n, Dataset.SPLITMODE_ABS);
        [accuracy, best_model, ~, Ypred] = k_clusters_accuracy(no_test, test_n, best_k(1), nb_trials);
        mean_accuracy_test = mean(accuracy, 1);
        fprintf('Mean accuracy achieved with test set for that k: %f\n', mean_accuracy_test);

        accuracy_test2(i,j) = mean_accuracy_test;
    end
end

Mte2 = mean(accuracy_test2, 2);
SDte2 = std(accuracy_test2, 0, 2);

figure;
hold on;
errorbar(n_range, Mte2, SDte2);
hold off;