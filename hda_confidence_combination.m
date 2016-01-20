load([param.root, 'matlab/hde_confidence_combination.mat']);

nb_conditions = length(Yte_pred2);
nb_trials = size(Yte_pred2{1}, 1);
nb_items = size(Yte_pred2{1}, 2);
nb_cat = length(unique(Yte_pred2{1}));

% Computing mean and std
res = zeros(nb_conditions, nb_trials);
for i = 1:nb_conditions
    res(i, :) = arrayfun(@(x)sum(Yte_pred2{i}(x,:) == Yte{i}(x,:)) / nb_items, 1:nb_trials);
end
M = mean(res, 2);
S = std(res, 0, 2);

% Display
Mbar = [M(1:3)'; M(4:6)'; M(7:9)'; M(10:12)'; M(13:15)'];
Sbar = [S(1:3)'; S(4:6)'; S(7:9)'; S(10:12)'; S(13:15)'];
figure;
hb = bar(Mbar);
set(gca,'xticklabel', {'F/T (shoulder)', 'springy model', 'joints', 'F/T (wrist)', 'F/T (wrist, cartesian)'});
legend('snapshot', 'fourier', 'both');
ylabel('Mean accuracy (% of good recognition)');
line([0, 6], [1/11, 1/11], 'Color', 'red');
barstd(hb, Mbar, Sbar);