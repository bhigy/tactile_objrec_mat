addpath(genpath('/home/bhigy/dev/bh_tsne'));
run('/home/bhigy/dev/vlfeat-0.9.20/toolbox/vl_setup')

[test, training] = X.split_cat(50, Dataset.SPLITMODE_ABS, X.instances);
[training, validation] = training.split_cat(25, Dataset.SPLITMODE_PCT, training.instances);

k_values = 2:5:57;
nb_trials = 10;
Ycomp_train = zeros(size(training.data,1),length(k_values));
Ycomp_valid = zeros(size(validation.data,1),length(k_values));
clusters = cell(length(k_values), 1);
clusters_labels = cell(length(k_values), 1);
score = zeros(length(k_values), nb_trials);
clustering_by = VisualDataset.INSTANCE;

i = 1;
for k = k_values
    for trial = 1:nb_trials
        % computing clusters on the training set
        [C, Ycomp_train(:,i)] = vl_kmeans(training.data', k);
        clusters(i) = {C};
        Ytrain = training.get_data_infos(clustering_by);
        most_freq = arrayfun(@(x) mode(Ytrain(Ycomp_train(:,i) == x)),1:k);
        clusters_labels(i) = {most_freq};

        Yvalid = validation.get_data_infos(clustering_by);
        for j = 1:size(validation.data, 1)
            [~, c] = min(vl_alldist(validation.data(j,:)', C));
            Ycomp_valid(j,i) = c;
            score(i, trial) = score(i, trial) + (Yvalid(j) == most_freq(c));
        end
        score(i, trial) = score(i, trial) / size(validation.data, 1);
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