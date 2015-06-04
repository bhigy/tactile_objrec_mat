addpath(genpath('/home/bhigy/dev/matlab'));

%% Loading all data
dataset = VisualDataset('/home/bhigy/data/venerdi26');

%% Configuration
config = 1;

switch config
    case 1
        % 1 instance x 2 labels
        samples = {'dish1' 'laundrydetergent1'};
        filter_by = VisualDataset.INSTANCE;
        cluster_by = VisualDataset.LABEL;
        k = length(samples);
    case 2
        %  1 instance x all labels
        samples = {'dish1' 'laundrydetergent1' 'mug1' 'soap1' 'sponge1' 'sprinkler1' 'washingup1'};
        filter_by = VisualDataset.INSTANCE;
        cluster_by = VisualDataset.LABEL;
        col_clustering = 1;
        k = length(samples);
    case 3
        % all instances x 2 labels - clustering on instances
        samples = {'dish' 'laundrydetergent'};
        filter_by = VisualDataset.LABEL;
        cluster_by = VisualDataset.INSTANCE;
        k = length(samples) * 4;
    case 4
        % all instances x 2 labels - clustering on labels
        samples = {'dish' 'laundrydetergent'};
        filter_by = VisualDataset.LABEL;
        cluster_by = VisualDataset.LABEL;
        k = length(samples);
    case 5
        % all instances x all labels - clustering on instances
        samples = dataset.get_ref_infos(VisualDataset.LABEL);
        filter_by = VisualDataset.LABEL;
        cluster_by = VisualDataset.INSTANCE;
        k = length(samples) * 4;
    case 6
        % all instances x all labels - clustering on labels
        samples = dataset.get_ref_infos(VisualDataset.LABEL);
        filter_by = VisualDataset.LABEL;
        cluster_by = VisualDataset.LABEL;
        k = length(samples);
end


%% Filtering unwanted samples
X = dataset.copy();
X.filter(filter_by, samples);

%% Clustering
[clusters, Y] = kmeans(X.data, k);

%% Computing pourcentage of good classification
data_infos = X.get_data_infos(cluster_by);
% for each cluster we compute the most frequent label
most_freq = arrayfun(@(x) mode(data_infos(Y == x)),1:k);
% and then we compare to the actual label
pourcentage = mean(arrayfun(@(x) most_freq(x),Y) == data_infos');
% computing the most frequent "retrieved label" by instance
retrieved_by_inst = arrayfun(@(x) most_freq(mode(Y(data_infos == x))),1:k);

%% ploting the clusters
% Dimension reduction
[U, S, V] = svd(X.data);
X_2D = U*S;

% Drawing
figure;
hold all;
plot_by = 2;
switch plot_by
    case 1 %clusters
        nb_colors = k;
        grouping = 'cluster';
    case 2 %instances
        nb_colors = length(X.get_ref_infos(VisualDataset.INSTANCE));
        grouping = 'instance';
    case 3 %labels
        nb_colors = length(X.get_ref_infos(VisualDataset.LABEL));
        grouping = 'label';
end

colors = hsv(nb_colors);
legends = {};
for i = 1:nb_colors
    switch plot_by
        case 1
            ind = Y == i;
        case 2
            ind = (X.get_data_infos(VisualDataset.INSTANCE) == i);
        case 3
            ind = (X.get_data_infos(VisualDataset.LABEL) == i);
    end
    lines = X_2D(ind, :);
    if ~isempty(lines)
        points = plot(lines(:,1), lines(:,2), 'MarkerEdgeColor', colors(i,:), 'Marker', '.', 'LineStyle', 'none');
        legends(end + 1) = {strcat(grouping, ' ', int2str(i))};
    end
end
legend(legends);
hold off
