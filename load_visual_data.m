addpath(genpath('/home/bhigy/dev/tactile_objrec_mat'));

%% Loading all data
dataset = VisualDataset('/home/bhigy/data/venerdi26');

%% Configuration
config = 6;

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
% Dimension reduction - SVD
[U, S, V] = svd(X.data);
result = U*S;

% Drawing
svd_points = Points(result(:,1), result(:,2));

plot_by = 3;
switch plot_by
    case 1 %clusters
        svd_points.draw(Y);
    case 2 %instances
        svd_points.draw(X.get_data_infos(VisualDataset.INSTANCE));
    case 3 %labels
        svd_points.draw(X.get_data_infos(VisualDataset.LABEL));
end

% Dimension reduction - t_NSE
addpath(genpath('/home/bhigy/dev/t_SNE'));
mappedX = tsne(dataset.data, []);
tsne_points = Points(mappedX(:,1), mappedX(:,2));
tsne_points.draw(dataset.get_data_infos(VisualDataset.LABEL));
% tsne_points.draw(Y);
