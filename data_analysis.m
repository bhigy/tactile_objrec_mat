addpath(genpath('/home/bhigy/dev/bh_tsne'));
run('/home/bhigy/dev/vlfeat-0.9.20/toolbox/vl_setup')

%% Clustering
k = length(unique(Y));
[clusters, Ycomp] = vl_kmeans(X.data', k);

%% Computing some measures
% for each cluster we compute the most frequent label
most_freq = arrayfun(@(x) mode(Y(Ycomp == x)),1:k);
% and then we compare to the actual label
pourcentage = mean(arrayfun(@(x) most_freq(x),Ycomp) == Y);
% computing the most frequent "retrieved label" by instance
retrieved_by_inst = arrayfun(@(x) most_freq(mode(Ycomp(Y == x))),1:k);

%% Ploting the clusters
% Dimension reduction - SVD
svd_points = X.get_2D_projection(Dataset.METH_SVD);
svd_points.draw(Y, labels);
svd_points.draw(Ycomp, arrayfun(@(x) labels(x), most_freq));

% Dimension reduction - t_NSE
tsne_points = X.get_2D_projection(Dataset.METH_TSNE);
tsne_points.draw(Y, labels);
tsne_points.draw(Ycomp', arrayfun(@(x) labels(x), most_freq));