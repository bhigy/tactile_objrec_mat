function [accuracy, best_model, Ypred, conf_matrix] = k_clusters_accuracy(Str, Svl, k, nb_trials)
% Computes the mean accuracy over several trials for one value of k
%   Str (SupervisedDataset):    training set
%   Svl (SupervisedDataset):    validation set
%   k (integer):                number of clusters
%   nb_trials (integer):      number of trials to compute the mean accuracy
    
    if (k > length(unique(Str.X, 'rows')))
        error('k to high considering the data (data may be redundant) !');
    end
    
    Xtr = Str.X;
    Ytr = Str.getY();
    Xvl = Svl.X;
    Yvl = Svl.getY();
    Yvl_pred = zeros(size(Xvl,1), 1);
    accuracy = zeros(nb_trials, 1);
    best_accuracy = 0;

    for trial = 1:nb_trials
        % computing clusters on the training set
        [C, Ytr_pred] = vl_kmeans(Xtr', k, 'Initialization', 'plusplus');
        Yc = arrayfun(@(x) mode(Ytr(Ytr_pred == x)),1:k);
        
        % remove clusters that don't have any point attached to them
        to_delete = find(isnan(Yc));
        if ~isempty(to_delete)
            disp([ num2str(length(to_delete)), ' empty clusters']);
            C(:,to_delete) = [];
        end

        % computing the predicted categories on the validation set
        for j = 1:size(Xvl, 1)
            [~, c] = min(vl_alldist(Xvl(j,:)', C));
            Yvl_pred(j) = Yc(c);
        end

        % computing the score
        confus = compute_confusion_matrix(Yvl, Yvl_pred);
        accuracy(trial) = accuracy_from_conf_matrix(confus);

        if accuracy(trial) > best_accuracy
            best_model = C;
            best_accuracy = accuracy(trial);
            conf_matrix = confus;
            Ypred =  Yvl_pred;
        end
    end
end

