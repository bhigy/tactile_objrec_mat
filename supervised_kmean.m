addpath(genpath('/home/bhigy/dev/bh_tsne'));
addpath(genpath('/home/bhigy/dev/objrecpipe_mat'));
run('/home/bhigy/dev/vlfeat-0.9.20/toolbox/vl_setup')

[test, training] = X.split_cat(50, Dataset.SPLITMODE_ABS, X.instances);
[training, validation] = training.split_cat(25, Dataset.SPLITMODE_PCT, training.instances);

k_values = 2:5:57;
nb_trials = 1;
clus_membership_train = zeros(size(training.data,1));
Ycomp_valid = zeros(size(validation.data,1));
clusters = cell(length(k_values), 1);
clusters_labels = cell(length(k_values), 1);
score = zeros(length(k_values), nb_trials);
clustering_by = VisualDataset.INSTANCE;
Ytrain = training.get_data_infos(clustering_by);
Yvalid = validation.get_data_infos(clustering_by);

i = 1;
for k = k_values
    for trial = 1:nb_trials
        % computing clusters on the training set
        [C, clus_membership_train(:,i)] = vl_kmeans(training.data', k);
        clusters(i) = {C};
        most_freq = arrayfun(@(x) mode(Ytrain(clus_membership_train(:,i) == x)),1:k);
        clusters_labels(i) = {most_freq};

        for j = 1:size(validation.data, 1)
            [~, c] = min(vl_alldist(validation.data(j,:)', C));
            Ycomp_valid(j,1) = most_freq(c);
        end
        confus = compute_confusion_matrix(Yvalid, Ycomp_valid);
        score(i, trial) = mean(arrayfun(@(x) confus(x,x)/sum(confus(x,:)), 1:size(confus, 1)));
        %score(i, trial) = score(i, trial) / size(validation.data, 1);
    end
    i = i + 1;
end

score_means = mean(score');
plot(k_min:k_inc:k_max, score_means);

% Dimension reduction - t_NSE
step = 2;
labels = validation.ref_instances;
tsne_valid = validation.get_2D_projection(Dataset.METH_TSNE);
tsne_valid.draw(validation.instances, labels);
tsne_valid.draw(Ycomp_valid(:,step)', arrayfun(@(x) labels(x), cell2mat(clusters_labels(step))));
tsne_train = training.get_2D_projection(Dataset.METH_TSNE);
tsne_train.draw(training.instances, labels);
tsne_train.draw(Ycomp_train(:,step)', arrayfun(@(x) labels(x), cell2mat(clusters_labels(step))));