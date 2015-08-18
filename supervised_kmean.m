addpath(genpath('/home/bhigy/dev/tactile_objrec_mat'));
init;

[test, training] = S.split(50, Dataset.SPLITMODE_ABS);
[training, validation] = training.split(50, Dataset.SPLITMODE_PCT);
kValues = 1:50:length(unique(training.X, 'rows'));

accuracy = kmeanAccuracy(training, validation, kValues, 10);

meanAccuracy = mean(accuracy, 2);
figure
plot(kValues, meanAccuracy);

meanAccuracy = mean(accuracy, 2);
sd = std(accuracy, 0, 2);
errorbar(kValues, meanAccuracy, sd);
legend('10', '25', '50', '75', '90');

% Dimension reduction - t_NSE
step = 2;
labels = validation.ref_instances;
tsne_valid = validation.get_2D_projection(Dataset.METH_TSNE);
tsne_valid.draw(validation.instances, labels);
tsne_valid.draw(Yvl_prec(:,step)', arrayfun(@(x) labels(x), cell2mat(clusters_labels(step))));
tsne_train = training.get_2D_projection(Dataset.METH_TSNE);
tsne_train.draw(training.instances, labels);
tsne_train.draw(Ycomp_train(:,step)', arrayfun(@(x) labels(x), cell2mat(clusters_labels(step))));

% Estimating K
nbTrials = 10;
[test, training] = dataset.split(50, Dataset.SPLITMODE_ABS, dataset.instances);
[k, accuracy, model] = chooseK(training, nbTrials, 0.1, 10);

% computing labels attached to clusters
Xtr = training.X;
Ytr = training.getY();
Ctr = zeros(size(Xtr, 1), 1);
for i = 1:size(Xtr, 1)
    [~, Ctr(i,1)] = min(vl_alldist(Xtr(i,:)', model));
end
Yc = arrayfun(@(x) mode(Ytr(Ctr == x)),1:k);

% Computing accuracy on test set
Xts = test.X;
Yts = test.getY();
Yts_pred = zeros(size(Xts, 1), 1);
for i = 1:size(Xts, 1)
    [~, c] = min(vl_alldist(Xts(i,:)', model));
    Yts_pred(i) = Yc(c);
end

% computing the score
confus = compute_confusion_matrix(Yts, Yts_pred);
score = mean(arrayfun(@(x) confus(x,x)/sum(confus(x,:)), 1:size(confus, 1)));


