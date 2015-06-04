FEATURES_DIR = '/home/bhigy/dev/objrecpipe_mat';
addpath(genpath(FEATURES_DIR));

run('/home/bhigy/dev/GURLS/gurls/utils/gurls_install.m');
    
curr_dir = pwd;
%cd([getenv('VLFEAT_ROOT') '/toolbox']);
%vl_setup;
cd(curr_dir);
clear curr_dir;

ICUBWORLDopts = ICUBWORLDinit('iCubWorld30');
obj_names = keys(ICUBWORLDopts.objects)';

dset_name = 'iCubWorld30';

feat_root_path = fullfile(root_path, [dset_name '_experiments'], feat_name);
X_path = fullfile(root_path, [dset_name '_experiments'], 'obj_rec_28', feat_name);
y_path = fullfile(root_path, [dset_name '_experiments'], 'obj_rec_28');

check_output_dir(X_path);
check_output_dir(y_path);

imset = 'test';

modality = 'lunedi22';
day = 1;
[Xte{day}, Yte{day}] = load_and_save_xy (feat_root_path, [], [], y_path, X_path, []);
