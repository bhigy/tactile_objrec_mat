% Computes kmeans algorithm
% -Input-
% data: data we want to cluster
% k: number of clusters
% -Output-
% clusters: the centers of the clusters
% categories: the category of each data vector

function [clusters, categories] = kmeans(data, k)

%% Initialization
% Computing the number of samples and the samples size
[n_samples, sample_size] = size(data);

% Initialisation of the clusters centers
clusters = data(ceil(rand(1,7)*n_samples),:);

difference = 1;
distances = zeros(k, 1);
categories = zeros(n_samples, 1);

%% Recomputing cluster centers as long as they change

while difference == 1
    % Re-computing the cluster's centers
    new_clusters = zeros(k, sample_size);
    nb_samples = zeros(1,k);
    for is = 1:n_samples
        % Computing distance with each cluster center
        for ic = 1:k
            distances(ic, 1) = sum((data(is,:) - clusters(ic,:)).^2);
        end
        % Finding the nearest one
        [~, pos] = min(distances);
        categories(is, 1) = pos;
        new_clusters(pos,:) = new_clusters(pos,:) + data(is,:);
        nb_samples(pos) = nb_samples(pos) + 1;
    end
    for ic = 1:k
        if nb_samples(ic) > 0
            new_clusters(ic,:) = new_clusters(ic,:) / nb_samples(ic);
        end
    end
    
    % Checking if the clusters changed
    difference = (sum(sum(clusters ~= new_clusters)) > 0);
    clusters = new_clusters;
end
