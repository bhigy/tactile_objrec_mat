%% Splitting the haptic data
S = BasicSupervisedDataset(X, Y);
N = min(count_occurences(Y));
S = S.split(N, Dataset.SPLITMODE_ABS);

nb_iter = 10;
accuracy = zeros(nb_iter, 1);
for i = 1:nb_iter
    [test, training] = S.split(param.nb_items_test, Dataset.SPLITMODE_ABS);
    [~, model] = evalc('gurls_train(training.X, training.Y)');
    [~, ypred] = evalc('gurls_test(model, test.X)');
    accuracy(i) = sum(ypred == test.Y) / length(test.Y);
end

mean_acc = mean(accuracy);
std_acc = std(accuracy);
fprintf('Mean accuracy: %f (std: %d)\n', mean_acc, std_acc);