load([param.root, 'matlab/hde_all_conditions_binary.mat']);

% Keep only grasp
cond_sel = ismember(conditions(:,1), 'grasp');
Ypred = Ypred(cond_sel,:,:,:,:);
confidence = confidence(cond_sel,:,:,:,:);

nb_conditions = size(Ypred, 1);
nb_trials = size(Ypred, 2);
nb_items = size(Ypred, 3);
nb_cats = size(Ypred, 4);

% Apply logistic function
conf_prob = 1 ./ (1 + exp(confidence));

% Perform coupling
prob = zeros(nb_conditions, nb_trials, nb_items, nb_cats);
for i = 1:size(conf_prob, 1)
    for j = 1:size(conf_prob, 2)
        for k = 1:size(conf_prob, 3)
            prob(i,j,k,:) = pairwise_coupling(squeeze(conf_prob(i,j,k,:,:)));
        end
    end
end

% Category predicted by uniform combination
[prob_comb] = squeeze(mean(prob, 1));
[~, Ypred_comb] = max(prob_comb, [], 3);

% Category predicted by voting among all conditions
% counts = zeros(nb_trials, nb_items, nb_cats);
% for i = 1:size(counts, 1)
%     for j = 1:size(counts, 2)
%         counts(i,j,:) = countOccurences(Ypred2(:,i,j), 1:nb_cats);
%     end
% end
% [m, Ypred_comb] = max(counts, [], 3);
% for i = 1:size(counts, 1)
%     for j = 1:size(counts, 2)
%         if sum(counts(i,j,:) == m(i,j)) > 1
%             Ypred_comb(i,j) = -1;
%         end
%     end
% end
accuracy = sum(Ypred_comb == Ytest, 2) / nb_items;
% undetermined = sum(Ypred_comb == -1, 2) / nb_items;
