load([param.root, 'matlab/hde_standardisation.mat']);

nb_conditions = length(Ypred);
nb_trials = size(Ypred{1}, 1);
nb_items = size(Ypred{1}, 2);
nb_cat = length(unique(Ypred{1}));

% Computing mean and std
res = zeros(nb_conditions, nb_trials);
for i = 1:nb_conditions
    res(i, :) = arrayfun(@(x)sum(Ypred{i}(x,:) == Ytest{i}(x,:)) / nb_items, 1:nb_trials);
end
M = mean(res, 2);
S = std(res, 0, 2);

% Display
Mbar = [M(1:2)'; M(3:4)'; M(5:6)'; 0 M(7)];
Sbar = [S(1:2)'; S(3:4)'; S(5:6)'; 0 S(7)];
figure;
hb = bar(Mbar);
set(gca,'xticklabel', {'springy model', 'joints', 'F/T (wrist, cartesian)', 'combined'});
legend('snapshot', 'standardised');
ylabel('Mean accuracy (% of good recognition)');
line([0, 5], [1/11, 1/11], 'Color', 'red');
barstd(hb, Mbar, Sbar);

