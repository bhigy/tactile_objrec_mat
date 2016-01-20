load([param.root, 'matlab/hde_modalities.mat']);

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
Mbar = [M(1:3)'; M(4:6)'; M(7:9)'; M(10:12)'; M(13:15)'];
Sbar = [S(1:3)'; S(4:6)'; S(7:9)'; S(10:12)'; S(13:15)'];
figure;
hb = bar(Mbar);
set(gca,'xticklabel', {'F/T (shoulder)', 'springy model', 'joints', 'F/T (wrist)', 'F/T (wrist, cartesian)'});
legend('snapshot', 'fourier', 'both');
ylabel('Mean accuracy (% of good recognition)');
line([0, 6], [1/11, 1/11], 'Color', 'red');
barstd(hb, Mbar, Sbar);

%%%
% modalities - slides for Lorenzo
%%%
% Mbar = [M(4:5)'; M(7:8)'; M(10:11)'];
% Sbar = [S(4:5)'; S(7:8)'; S(10:11)'];
% figure;
% hb = bar(Mbar);
% set(hb(1),'FaceColor',[0 .4 .6]);
% set(hb(2),'FaceColor',[1 .65 0]);
% set(gca,'xticklabel', {'hand springs', 'joints', 'F/T'});
% set(gca,'FontSize',26)
% legend('raw values', 'fourier', 'both');
% ylabel('Mean accuracy (% of good recognition)');
% line([0, 4], [1/11, 1/11], 'Color', 'red', 'LineWidth', 1.5);
% barstd(hb, Mbar, Sbar);

% Confusion matrix + bars
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
bar(D([4:5, 7:8, 10:11, 13:14],:));
% set(gca,'xticklabel', {'springy model - snapshot', 'springy model - fourier', 'joints - snapshot', 'joints - fourier', ...
%                        'F/T (wrist) - snapshot', 'F/T (wrist) - fourier', 'F/T (wrist, cartesian) - snapshot', 'F/T (wrist, cartesian) - fourier'});
legend(objects);
ylabel('Mean accuracy (% of good recognition)');
line([0, 9], [1/11, 1/11], 'Color', 'red');
figure;
intensity_matrix(C{5});

% Combining confidence (sum)
C = cell(1, nb_trials);
Ypred_comb = zeros(nb_trials, nb_items);
for i = 1:nb_trials
    C{i} = zeros(nb_items, nb_cat);
    for j = [7, 14]%[1:2, 4:5, 7:8, 10:11, 13:14]
        C{i} = C{i} + confidence{j, i};
    end
    [~, pred_cat] = max(C{i}, [], 2);
    Ypred_comb(i, :) = pred_cat';
end
res = arrayfun(@(x)sum(Ypred_comb(x,:) == Ytest{1}(x,:)) / nb_items, 1:nb_trials);
M = mean(res, 2);
S = std(res, 0, 2);
confusion = zeros(nb_cat);
for i = 1:nb_trials
    conf = compute_confusion_matrix(Ypred_comb(i,:), Ypred{1}(i,:));
    confusion = confusion + conf;
end
confusion = confusion ./ (nb_trials * param.nb_items_test);
figure;
intensity_matrix(confusion);

% Combining confidence (max)
cond_range = [1:2, 4:5, 7:8, 10:11, 13:14];
Ypred_comb = zeros(nb_trials, nb_items);
for trial = 1:nb_trials
    max_cond = zeros(nb_items, length(cond_range));
    pred_max_cond = zeros(nb_items, length(cond_range));
    for i_cond = 1:length(cond_range)
        cond = cond_range(i_cond);
        [mc, i_mc] = max(confidence{cond,trial}, [], 2);
        max_cond(:,i_cond) = mc;
        pred_max_cond(:,i_cond) = i_mc;
    end
    [~, i_max_max] = max(max_cond, [], 2);
    for item = 1:nb_items
        Ypred_comb(trial, item) = pred_max_cond(item, i_max_max(item))';
    end
end
res = arrayfun(@(x)sum(Ypred_comb(x,:) == Ytest{1}(x,:)) / nb_items, 1:nb_trials);
M = mean(res, 2);
S = std(res, 0, 2);
confusion = zeros(nb_cat);
for i = 1:nb_trials
    conf = compute_confusion_matrix(Ypred_comb(i,:), Ypred{1}(i,:));
    confusion = confusion + conf;
end
confusion = confusion ./ (nb_trials * param.nb_items_test);
figure;
intensity_matrix(confusion);

