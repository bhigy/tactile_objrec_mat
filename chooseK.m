function [k, accuracy, model] = chooseK(S, nbTrials, impMin, impStep)
    % Select the best value for k, i.e. the one after which we don't have
    % any improvement
    % S (SupervisedDataset): the dataset 
    % nbTrials (integer): the number of trials for each k
    % impMin (decimal): the minimal improvement we allow
    % impStep (integer): the number of steps the improvement should be
    % below impMin before we stop
    
    [Str, Svl] = S.split(50, Dataset.SPLITMODE_PCT, S.instances);

    if ~exist('nbTrials', 'var') || isempty(nbTrials)
        nbTrials = 10;
    end
    
    Xtr = Str.X;
    Xvl = Svl.X;
    Ytr = Str.getY();
    Yvl = Svl.getY();
    Yvl_pred = zeros(size(Xvl,1), 1);
    
    k = 0;
    prevMeanScore = 0;
    nbSteps = 0;
    accuracy = 0;
    while nbSteps < impStep
        k = k + 1;
        bestScore = 0;
        bestSolution = zeros(k, size(Xtr, 2));
        score = zeros(nbTrials, 1);
        for trial = 1:nbTrials
            % computing clusters on the training set
            [C, Ytr_pred] = vl_kmeans(Xtr', k);
            
            % computing the predicted categories on the validation set
            Yc = arrayfun(@(x) mode(Ytr(Ytr_pred == x)),1:k);
            for j = 1:size(Xvl, 1)
                [~, c] = min(vl_alldist(Xvl(j,:)', C));
                Yvl_pred(j) = Yc(c);
            end
            
            % computing the score
            confus = compute_confusion_matrix(Yvl, Yvl_pred);
            score(trial) = mean(arrayfun(@(x) confus(x,x)/sum(confus(x,:)), 1:size(confus, 1)));
            
            if score(trial) > bestScore
                bestSolution = C;
            end
        end
        
        % Checking the improvement
        meanScore = mean(score);
        disp(['k = ', num2str(k), ' - mean score = ', num2str(meanScore * 100), '%']);
        if (meanScore - accuracy) / accuracy * 100 >= impMin
            nbSteps = 0;
            accuracy = meanScore;
            model = bestSolution;
        else
            nbSteps = nbSteps + 1;
        end
        prevMeanScore = meanScore;
    end
    k = k - impStep;
end