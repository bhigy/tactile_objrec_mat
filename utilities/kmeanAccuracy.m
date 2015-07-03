function accuracy = kmeanAccuracy(Str, Svl, kValues, nbTrials)
    if ~exist('nbTrials', 'var') || isempty(nbTrials)
        nbTrials = 10;
    end
    
    if (max(kValues) > length(unique(Str.X, 'rows')))
        error('kValues to high considering the data (data may be redundant) !');
    end
    
    Xtr = Str.X;
    Ytr = Str.getY();
    Xvl = Svl.X;
    Yvl = Svl.getY();
    Yvl_pred = zeros(size(Xvl,1), 1);
    accuracy = zeros(length(kValues), nbTrials);

    i = 1;
    for k = kValues
        disp(['k = ', num2str(k)]);
        for trial = 1:nbTrials
            % computing clusters on the training set
            [C, Ytr_pred] = vl_kmeans(Xtr', k); %, 'Initialization', 'plusplus') ;
            mostFreq = arrayfun(@(x) mode(Ytr(Ytr_pred == x)),1:size(C,2));
            % remove clusters that don't have any point attached to them
            toDelete = find(isnan(mostFreq));
            if ~isempty(toDelete)
                disp([ num2str(length(toDelete)), ' empty clusters']);
                C(:,toDelete) = [];
                mostFreq(toDelete) = [];
            end

            for j = 1:size(Xvl, 1)
                [~, c] = min(vl_alldist(Xvl(j,:)', C));
                Yvl_pred(j) = mostFreq(c);
            end
            confus = compute_confusion_matrix(Yvl, Yvl_pred);
            accuracy(i, trial) = mean(arrayfun(@(x) confus(x,x)/sum(confus(x,:)), 1:size(confus, 1)));
        end
        i = i + 1;
    end
end