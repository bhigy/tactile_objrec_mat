init;

%% Clustering
k = length(unique(Y));
[clusters, clus_membership] = vl_kmeans(X.data', k);


%% Computing some measures
% for each cluster we compute the most frequent label
most_freq = arrayfun(@(x) mode(Y(Ycomp == x)),1:k);
% we can then attach a computed label to each element
Ycomp = arrayfun(@(x) most_freq(x),clus_membership);
% and then we compare to the actual label
confus = compute_confusion_matrix(Y, Ycomp);
score = mean(arrayfun(@(x) confus(x,x)/sum(confus(x,:)), 1:size(confus, 1)));
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