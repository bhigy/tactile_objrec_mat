%% Condition-specific
ResMod = load([param.root, 'matlab/hde_modalities.mat']);

nb_items = size(ResMod.Ypred{1}, 2);
nb_cat = length(unique(ResMod.Ypred{1}));
nb_trials = size(ResMod.Ypred{1}, 1);

% Computing mean and std
nb_conditions = length(ResMod.Ypred);
res = zeros(nb_conditions, nb_trials);
for i = 1:nb_conditions
    res(i, :) = arrayfun(@(x)sum(ResMod.Ypred{i}(x,:) == ResMod.Ytest{i}(x,:)) / nb_items, 1:nb_trials);
end
MMod = reshape(mean(res, 2) * 100, 3, nb_conditions / 3)';
SMod = reshape(std(res, 0, 2) * 100, 3, nb_conditions / 3)';

%% Concat
ResCat = load([param.root, 'matlab/hde_standardisation.mat']);

% Computing mean and std
nb_conditions = length(ResCat.Ypred);
res = zeros(nb_conditions, nb_trials);
for i = 1:nb_conditions
    res(i, :) = arrayfun(@(x)sum(ResCat.Ypred{i}(x,:) == ResCat.Ytest{i}(x,:)) / nb_items, 1:nb_trials);
end
MCat = mean(res, 2) * 100;
SCat = std(res, 0, 2) * 100;

%% Sum
% Combining confidence (sum)
C = cell(1, nb_trials);
Ypred_comb = zeros(nb_trials, nb_items);
for i = 1:nb_trials
    C{i} = zeros(nb_items, nb_cat);
    for j = [1:2, 4:5, 7:8, 13:14]
        C{i} = C{i} + ResMod.confidence{j, i};
    end
    [~, pred_cat] = max(C{i}, [], 2);
    Ypred_comb(i, :) = pred_cat';
end
res = arrayfun(@(x)sum(Ypred_comb(x,:) == ResMod.Ytest{1}(x,:)) / nb_items, 1:nb_trials);
MSum = mean(res, 2) * 100;
SSum = std(res, 0, 2) * 100;

%% Conf-comb
ResComb = load([param.root, 'matlab/hde_confidence_combination.mat']);

% Computing mean and std
nb_conditions = length(ResComb.Yte_pred2);
res = zeros(nb_conditions, nb_trials);
for i = 1:nb_conditions
    res(i, :) = arrayfun(@(x)sum(ResComb.Yte_pred2{i}(x,:) == ResComb.Yte{i}(x,:)) / nb_items, 1:nb_trials);
end
MComb = mean(res, 2) * 100;
SComb = std(res, 0, 2) * 100;

%% Binary
ResBin = load([param.root, 'matlab/binary/for_Bertrand_EP Grasp both all modalities.mat']);
% Final score
ScoreBin = 65;
% Histograms - grasp
scores = ResBin.for_Bertrand.scoreTensor * 100;
nb_conditions = size(scores, 3);
nb_classifiers = nb_cat * (nb_cat - 1) / 2;
[MaxBin, ~] = max(scores, [], 3);
MBin = sum(MaxBin(:)) / nb_classifiers;
Hist = arrayfun(@(x)sum(sum(MaxBin == scores(:,:,x))), 1:nb_conditions);
Hist = (Hist - nb_cat * nb_cat + nb_classifiers) / nb_classifiers;
Hist = reshape(Hist, nb_conditions / 2, 2);
objects = ResBin.for_Bertrand.object;

% Scores - all
ResBinAll = load([param.root, 'matlab/binary-sign/for_Bertrand.mat']);
scores = ResBinAll.for_Bertrand.scoreTensor;
nb_conditions = size(scores, 3);
nb_classifiers = nb_cat * (nb_cat - 1) / 2;
[Max, ~] = max(scores, [], 3);
MBinAll = sum(Max(:)) / nb_classifiers;
modalities = [1:4; 5:8; 9:12; 13:16; 17:20];
BestAll = arrayfun(@(x)sum(sum(Max == scores(:,:,x))), 1:nb_conditions);
BestAll = (BestAll - nb_cat * nb_cat + nb_classifiers) / nb_classifiers * 100;
BestAll = reshape(BestAll, nb_conditions / 5, 5);
BestModAll = arrayfun(@(x)sum(sum(Max == max(scores(:,:,modalities(x, :)), [], 3))), 1:size(modalities, 1));
BestModAll = (BestModAll - nb_cat * nb_cat + nb_classifiers) / nb_classifiers * 100;
eps = [1:4:17; 2:4:18; 3:4:19; 4:4:20];
BestEPAll = arrayfun(@(x)sum(sum(Max == max(scores(:,:,eps(x, :)), [], 3))), 1:size(eps, 1));
BestEPAll = (BestEPAll - nb_cat * nb_cat + nb_classifiers) / nb_classifiers * 100;

% Histograms - all
HistAll = zeros(9, 2);
directory = [param.root, 'matlab/binary/'];
S = load([param.root, 'matlab/binary-sign/for_Bertrand_All EP - modality FT.mat']);
HistAll(1, 1) = S.for_Bertrand.score_final;
HistAll(1, 2) = S.for_Bertrand.super_score_final;
S = load([directory, 'for_Bertrand_All EP - modality springy.mat']);
HistAll(2, 1) = S.for_Bertrand.score_final;
HistAll(2, 2) = S.for_Bertrand.super_score_final;
S = load([directory, 'for_Bertrand_All EP - modality state.mat']);
HistAll(3, 1) = S.for_Bertrand.score_final;
HistAll(3, 2) = S.for_Bertrand.super_score_final;
S = load([directory, 'for_Bertrand_EP Grasp snapshot all modalities.mat']);
HistAll(4, 1) = S.for_Bertrand.score_final;
HistAll(4, 2) = S.for_Bertrand.super_score_final;
S = load([directory, 'for_Bertrand_EP Grasp fourier all modalities.mat']);
HistAll(5, 1) = S.for_Bertrand.score_final;
HistAll(5, 2) = S.for_Bertrand.super_score_final;
S = load([directory, 'for_Bertrand_EP Grasp both all modalities.mat']);
HistAll(6, 1) = S.for_Bertrand.score_final;
HistAll(6, 2) = S.for_Bertrand.super_score_final;
S = load([directory, 'for_Bertrand_EP Rotate fourier all modalities.mat']);
HistAll(7, 1) = S.for_Bertrand.score_final;
HistAll(7, 2) = S.for_Bertrand.super_score_final;
S = load([directory, 'for_Bertrand_EP Weigh fourier all modalities.mat']);
HistAll(8, 1) = S.for_Bertrand.score_final;
HistAll(8, 2) = S.for_Bertrand.super_score_final;
S = load([directory, 'for_Bertrand_All EP - all modalities.mat']);
HistAll(9, 1) = S.for_Bertrand.score_final;
HistAll(9, 2) = S.for_Bertrand.super_score_final;
HistAll = HistAll * 100;

%% Binary-sign
MScoreBSi = ResBin.for_Bertrand.score_final * 100;

%% Trials combination
ResTrialsCombMod = load([param.root, 'matlab/hde_trials_combination.mat']);
MTrialsCombMod = ResTrialsCombMod.M(:, sort([1:3:15, 2:3:15])) * 100;
ResTrialsCombEP.M = [   0.8081    0.7576    0.6465    0.4747
                        0.8914    0.8586    0.7222    0.5328
                        0.9318    0.9004    0.7781    0.5465
                        0.9589    0.9271    0.8009    0.5765
                        0.9841    0.9343    0.8276    0.5974
                        0.9957    0.9426    0.8355    0.6180
                        1.0000    0.9495    0.8535    0.6389
                        1.0000    0.9495    0.8889    0.6768
                        1.0000    0.9091    0.9091    0.6364];
MTrialsCombEP = ResTrialsCombEP.M * 100;



%% ********************************************************************* %%
folderSave = '/home/bhigy/data/icub/haptic_data_20151028/pictures/IROS_2016/';

labelAnalog = '  F/T\newline(raw)';
labelSpringy = ' Hand\newlinesprings';
labelState = '  Joints\newlinepositions';
labelWrench = '       F/T\newline(wrist, palm)';
labelCartWrench = '       F/T\newline(wrist, root)';
titleAccuracy = '       Mean accuracy\newline(% of good recognition)';
titlePercentage = 'Percentage of binary classifiers\newline      that achive best score';

%% Multi-class classifiers
figure('Position', [0, 0, 1920, 1080]);
MBar = MMod(1:end-1, 1:2);
SBar = SMod(1:end-1, 1:2);
hb = bar(MMod(1:end-1, 1:2));
set(hb(1),'FaceColor',[0 .4 .6]);
set(hb(2),'FaceColor',[1 .65 0]);
set(gca, 'fontsize', 24)
set(gca, 'xticklabel', {labelAnalog, labelSpringy, labelState, labelWrench, labelCartWrench});
legend('snapshot', 'fourier');
ylabel(titleAccuracy);
line([0, 6], [100/11, 100/11], 'Color', 'red');
% barstd(hb, MBar, SBar);
export_fig([folderSave, 'modalities.pdf'], '-transparent');

%% Pair-wise binary classifiers
fig = figure('Position', [0, 0, 1920, 1080]);
imagesc(MaxBin);
colorbar;
objectsLabels = {'Blue ball', 'Tea box', 'Yellow cup', 'Empty water bottle', ...
    'Full water bottle', 'Green bottle', 'Round box', 'Sponge', 'Tennis ball', ...
    'Toy', 'Turtle'};
set(gca,'fontsize',18)
set(gca, 'xticklabel', objectsLabels, 'XTickLabelRotation', 45);
set(gca, 'yticklabel', objectsLabels);
export_fig([folderSave, 'binary_pairs.pdf'], '-transparent');

%% Binary Classifiers
figure('Position', [0, 0, 1920, 1080]);
hb = bar(Hist);
set(hb(1),'FaceColor',[0 .4 .6]);
set(hb(2),'FaceColor',[1 .65 0]);
set(gca,'fontsize',24)
set(gca, 'xticklabel', {labelAnalog, labelSpringy, labelState, labelWrench, labelCartWrench});
legend('snapshot', 'fourier');
ylabel(titlePercentage);
export_fig([folderSave, 'binary.pdf'], '-transparent');

%% Combining
sinapov = 51.3;
Mbar = [MMod(3, 1); MCat(end); MSum; sinapov; MComb; ScoreBin; MScoreBSi];
figure('Position', [0, 0, 1920, 1080]);
hb = bar(Mbar);
set(hb(1),'FaceColor',[0 .4 .6]);
set(gca,'fontsize',18)
set(gca,'xticklabel', {'    Joints\newline(snapshot)', 'Concatenation', ....
    'Averaging', '  Averaging [17]', 'Hierarchical\newline(multi-class)', ...
    'Hierarchical\newline(binary)', ' Hierarchical\newline(binary-sign)'});
ylabel(titleAccuracy);
export_fig([folderSave, 'combination.pdf'], '-transparent');

%% Combining - Lorenzo
sinapov = 51.3;
Mbar = [MMod(3, 1); MCat(end); MSum; sinapov; MComb; MScoreBSi];
figure('Position', [0, 0, 1920, 1080]);
hb = bar(Mbar);
set(hb(1),'FaceColor',[0 .4 .6]);
set(gca,'fontsize',18)
set(gca,'xticklabel', {'    Joints\newline(snapshot)', '  Concatenation', ....
    ' Averaging', '        Average\newline   Sinapov et al.\newline         (2014)', ...
    '    Hierarchical\newline    (multi-class)', '    Hierarchical\newline    (binary-sign)'});
ylabel(titleAccuracy);
export_fig([folderSave, 'combination_lorenzo.pdf'], '-transparent');

%% Binary classifiers - all strategies
figure('Position', [0, 0, 1920, 1080]);
hb = bar(HistAll(4:end,1));
set(hb(1),'FaceColor',[0 .4 .6]);
set(gca,'fontsize',18);
set(gca,'xticklabel', {' Grasp EP\newline(snapshot)', 'Grasp EP\newline(fourier)', ...
    'Grasp EP\newline (both)', 'Rotate EP', 'Weigh EP', 'All EPs'});
ylabel(titlePercentage);
export_fig([folderSave, 'all_strategies.pdf'], '-transparent');
% hb = bar(HistAll);
% set(hb(1),'FaceColor',[0 .4 .6]);
% set(hb(2),'FaceColor',[1 .65 0]);
% set(gca,'fontsize',18);
% set(gca,'xticklabel', {'F/T (all)', 'hand springs', 'joints', 'Grasping\newlinesnapshot', 'Grasping\newlinefourier', 'Grasping\newlineboth', 'Weighing', 'Rotating', 'All conditions\newlinecombined'});
% legend('normal', 'super');
% ylabel('Percentage of binary classifiers that achieve best score');

%% Combining several grasps (modalities)
figure('Position', [0, 0, 1920, 1080]);
plot(MTrialsCombMod(:, 1:2:10), 'LineWidth', 1.5, 'MarkerSize', 15, 'Marker', '.');
set(gca,'fontsize',18);
ylabel(titleAccuracy);
xlabel('Number of grasps');
axis([0, 10, 0, 100]);
legend({'F/T (raw)', 'Hand springs', 'Joints positions', 'F/T (wrist, palm)', 'F/T (wrist, root)'}, ...
    'Location','none', 'Location', 'northeast');
%legend('F/T (raw)', 'Hand springs model', 'Joints positions', 'F/T (wrist, palm ref)', 'F/T (wrist, root ref)', 'Location','northoutside');
export_fig([folderSave, 'several_grasps_mod.pdf'], '-transparent');

%% Combining several grasps (EPs)
figure('Position', [0, 0, 1920, 1080]);
plot(MTrialsCombEP, 'LineWidth', 1.5, 'MarkerSize', 15, 'Marker', '.');
set(gca,'fontsize',18);
ylabel(titleAccuracy);
xlabel('Number of grasps');
axis([0, 10, 0, 100]);
legend({'All EPs', 'Grasp', 'Rotate', 'Weigh'}, 'Location', 'east');
export_fig([folderSave, 'several_grasps_ep.pdf'], '-transparent');