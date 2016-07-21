home_folder = '/home/local/IIT/bhigy/';
addpath(genpath([home_folder, 'dev/bh_tsne']));
addpath(genpath([home_folder, 'dev/tactile_objrec_mat']));
% addpath(genpath([home_folder, 'dev/objrecpipe_mat']));
addpath(genpath([home_folder, 'dev/linspecer']));
addpath(genpath([home_folder, 'dev/matutils']));

% run('/home/bhigy/dev/vlfeat-0.9.20/toolbox/vl_setup');
run([home_folder, 'dev/GURLS/gurls/utils/gurls_install.m']);

format long