% Main script controlling the overall pipeline
addpath(genpath('/home/bhigy/dev/tactile_objrec_mat'));
init;

%% Parameters
enum.dataset.PRETEST = 1;
enum.dataset.HAPTIC1 = 2;    % Set with 2 fingers and no tactile data
enum.dataset.WEIGH   = 3;
enum.dataset.HAPTIC2 = 4;    % Complete set

% Branching parameters
do_load               = 0;
do_extract_actions    = 0;
do_analyse            = 0;

param = hd_init(enum.dataset, enum.dataset.HAPTIC2);

%% Data loading
if do_load == 1
    disp('-- Loading raw data');
    raw_data = hd_load([param.root, 'dump/']);
    
    save([param.root, param.filenames.raw], '-v7.3', 'raw_data');
end

if do_extract_actions == 1
    load([param.root, param.filenames.raw]);
    
    disp('-- Filtering');
    raw_data.labels = erase(raw_data.labels, param.invalid_trials);

    disp('-- Extracting actions');
    grasp  = hd_extract_sequence(raw_data, param.raw_cols, 0, 1);
    weigh  = hd_extract_sequence(raw_data, param.raw_cols, 2, 3);
    rotate = hd_extract_sequence(raw_data, param.raw_cols, 4, 5);

    labels = raw_data.labels{3};
    save([param.root, param.filenames.raw_actions], 'labels', 'grasp', 'weigh', 'rotate');
end

%% Analysis
if do_analyse == 1
    load([param.root, param.filenames.raw_actions]);
    
    disp('-- Computing features')
    t_snapshot = grasp.t_end - param.grasp_duration / 2;
    Xs = hdf_snapshot(grasp, t_snapshot, [0 1 1 0 1 1 0]);
    
    ft = rotate.analog;
    Xf1 = hdf_fourier(hd_extract_col(ft, 2));
    Xf2 = hdf_fourier(hd_extract_col(ft, 3));
    Xf3 = hdf_fourier(hd_extract_col(ft, 4));
    Xf4 = hdf_fourier(hd_extract_col(ft, 5));
    Xf5 = hdf_fourier(hd_extract_col(ft, 6));
    Xf6 = hdf_fourier(hd_extract_col(ft, 7));
    
    [Xnb, Xmean, Xstd] = hd_compute_moments(grasp.skin_comp, 2:105);
    Xtn = hdf_fourier(Xnb);
    Xtm = hdf_fourier(Xmean);
    Xts = hdf_fourier(Xstd);
    
    X = [Xtm Xts];
    if param.standardize == 1
        X = standardize_matrix(X);
    end
    
    [Y, objects] = labels_to_Y(labels);

    disp('-- Analysing data');
%     hda_kmeans;
    hda_rls;
end