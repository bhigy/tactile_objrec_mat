load([param.root, 'matlab/hde_modalities.mat']);

nb_cond     = length(Ypred);
nb_trials   = size(Ypred{1}, 1);
nb_items    = size(Ypred{1}, 2);
nb_cat      = length(unique(Ypred{1}));
k_range     = 2:9;

Ysub  = cell(length(k_range), 1);
Ypred = cell(length(k_range), 1);
accuracy = cell(length(k_range), 1);
for i_k = 1:length(k_range)
    k = k_range(i_k);
    Ysub{i_k}  = cell(nb_cond, nb_trials);
    Ypred{i_k} = cell(nb_cond, nb_trials);
    accuracy{i_k} = zeros(nb_cond, nb_trials);
    for cond = 1:nb_cond
        for trial = 1:nb_trials
            [Ysub{i_k}{cond, trial}, Ypred{i_k}{cond, trial}] = hda_combine_trials(Ytest{cond}(trial, :)', confidence{cond, trial}, k);
            accuracy{i_k}(cond, trial) = sum(Ysub{i_k}{cond, trial} == Ypred{i_k}{cond, trial}) / length(Ysub{i_k}{cond, trial});
        end
    end
end

M = zeros(length(k_range), nb_cond);
for i_k = 1:length(k_range)
    M(i_k, :) = mean(accuracy{i_k},2);
end