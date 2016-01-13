load([param.root, 'matlab/hde_force_torque.mat']);

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
Mbar = [M([1, 4, 7])'; M([2, 5, 8])'; M([3, 6, 9])'];
Sbar = [S([1, 4, 7])'; S([2, 5, 8])'; S([3, 6, 9])'];
figure;
hb = bar(Mbar);
% set(gca,'xticklabel', {'F/T (shoulder)', 'F/T (wrist)', 'F/T (wrist, cartesian)'});
% legend('grasp', 'weigh', 'rotate');
set(gca,'xticklabel', {'grasp', 'weigh', 'rotate'});
legend('F/T (shoulder)', 'F/T (wrist)', 'F/T (wrist, cartesian)');
ylabel('Mean accuracy (% of good recognition)');
line([0, 4], [1/11, 1/11], 'Color', 'red');
barstd(hb, Mbar, Sbar);

%%%
% F/T cart_wrench - slides for Lorenzo
%%%
Mbar = [M(7)'; M(8)'; M(9)'];
Sbar = [S(7)'; S(8)'; S(9)'];
figure;
hb = bar(Mbar, 'FaceColor',[0 .4 .6]);
set(gca,'xticklabel', {'grasp', 'weigh', 'rotate'});
set(gca,'FontSize',26)
ylabel('Mean accuracy (% of good recognition)');
line([0, 4], [1/11, 1/11], 'Color', 'red', 'LineWidth', 1);
barstd(hb, Mbar, Sbar);


% Confusion matrix
C = cell(nb_conditions, 1);
D = zeros(nb_conditions, nb_cat);
for i = 1:nb_conditions
    C{i} = zeros(nb_cat);
    for j = 1:nb_trials
        conf = compute_confusion_matrix(Ytest{i}(j,:), Ypred{i}(j,:));
        C{i} = C{i} + conf;
    end
    C{i} = C{i} ./ (nb_trials * param.nb_items_test);
    D(i, :) = diag(C{i});
end
figure;
bar(D([1:9],:));
set(gca,'xticklabel', {'analog - grasp', 'analog - weigh', 'analog - rotate', 'wrench - grasp', 'wrench - weigh' ...
                       'wrench - rotate', 'cart_wrench - grasp', 'cart_wrench - weigh', 'cart_wrench - rotate'});
legend(objects);
ylabel('Mean accuracy (% of good recognition)');
line([0, 10], [1/11, 1/11], 'Color', 'red');
figure;
intensity_matrix(C{4});