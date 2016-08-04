% Main script controlling the overall pipeline
conf;
init;

%% Parameters
enum.dataset.PRETEST = 1;
enum.dataset.HAPTIC1 = 2;   % Set with 2 fingers and no tactile data
enum.dataset.WEIGH   = 3;
enum.dataset.HAPTIC2 = 4;   % Complete set, bad wrench
enum.dataset.HAPTIC3 = 5;   % No tactile data, no ring and little finger

% Branching parameters
do_load         = false;
do_extract_feat = false;
do_analyse      = true;

param = hd_init_params(enum.dataset, enum.dataset.HAPTIC3, home_folder);

%% Data loading 
if do_load
    disp('-- Loading data');
    [data, labels] = hd_load(param);
    save([param.root, param.filenames.raw_actions], 'labels', 'data');
end

if do_extract_feat
    disp('-- Transforming the data into X and Y');
    load([param.root, param.filenames.raw_actions]);
    actions = {'grasp', 'weigh', 'rotate'};
    modalities = {'analog', 'springy', 'state', 'wrench', 'cart_wrench'};
    features = {'snapshot', 'fourier'};
    [X, conditions] = hd_extract_features(data, actions, modalities, features, param);
    [Y, objects] = labels_to_Y(labels);
    save([param.root, param.filenames.XY], 'X', 'Y', 'objects', 'conditions');
end

%% Analysis
if do_analyse
    disp('-- Analysing data');
    load([param.root, param.filenames.XY]);
    nb_iter = 10;
    
%     disp('--- Condition-specific multi-class classifiers')
%     [Ypred, Ytest, confidence] = hda_rls(X, Y, nb_iter, param.nb_items_test);
%     save([param.root, 'matlab/hde_all_conditions.mat'], 'Ypred', 'Ytest', 'confidence', 'contexts');

%     disp('--- Condition-specific binary classifiers classifiers')
%     [Xsub, Ysub] = hd_subsample(X(1:2), Y, 3);
%     [Ypred, Ytest, confidence] = hda_binary_rls(Xsub, Ysub, 2, param.nb_items_test);
%     [Ypred, Ytest, confidence] = hda_binary_rls(X, Y, nb_iter, param.nb_items_test);
%     save([param.root, 'matlab/hde_all_conditions_binary.mat'], 'Ypred', 'Ytest', 'confidence', 'conditions');

%     disp('--- Concatenation');
%     Xconcat{1} = [X{ismember(conditions(:,1), 'grasp') & ismember(conditions(:,3), 'snapshot')}];
%     Xconcat{2} = [X{ismember(conditions(:,1), 'grasp') & ismember(conditions(:,3), 'fourier')}];
%     Xconcat{3} = [X{ismember(conditions(:,1), 'grasp')}];
%     [Ypred, Ytest, confidence] = hda_rls(Xconcat, Y, nb_iter, param.nb_items_test);
%     save([param.root, 'matlab/hde_modalities.mat'], 'Ypred', 'Ytest', 'confidence');

%     disp('-- Confidence combination');
%     Xconcat{3} = X(ismember(conditions(:,1), 'grasp'));
%     [Ytr, Ytr_pred1, Ytr_pred2, Yte, Yte_pred1, Yte_pred2, confidence] = hda_hierarchical_rls(X, Y, nb_iter, param.nb_items_test);
%     save([param.root, 'matlab/hde_confidence_combination.mat'], 'Ytr', 'Ytr_pred1', 'Ytr_pred2', 'Yte', 'Yte_pred1', 'Yte_pred2', 'confidence');
%     [Ytr, Ytr_pred1, Yva, Yva_pred1, Yva_pred2, Yte, Yte_pred1, Yte_pred2, confidence] = hda_hierarchical_rls_with_val(X, Y, nb_iter, 10, param.nb_items_test);
%     save([param.root, 'matlab/hde_confidence_combination.mat'], 'Ytr', 'Ytr_pred1', 'Yva', 'Yva_pred1', 'Yva_pred2', 'Yte', 'Yte_pred1', 'Yte_pred2', 'confidence');

%     disp('-- Trials combination');
%     hde_combine_trials_modalities;
%     save([param.root, 'matlab/hde_trials_combination.mat'], 'M');
    
%     [Ypred, Ytest, confidence] = hde_moments;
%     hde_moments_res.Ypred = Ypred;
%     hde_moments_res.Ytest = Ytest;
%     hde_moments_res.conf= confidence;

end