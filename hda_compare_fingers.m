% Compare the information provided by the different fingers
addpath(genpath('/home/bhigy/dev/tactile_objrec_mat'));
init;


%% Parameters
SET_PRETEST = 1;

set = SET_PRETEST;  % set to be used

hd_init;


%% Computing accuracy for different fingers
disp('-- Thumb');
use_finger = [1 0 0 0];
use_data   = [1 0 1 1 1];
hd_prepare;
hd_analyze_accuracy;

disp('-- Middle finger');
use_finger = [0 0 1 0];
use_data   = [1 0 1 1 1];
hd_prepare;
hd_analyze_accuracy;

disp('-- All fingers');
use_finger = [1 0 1 0];
use_data   = [1 0 1 1 1];
hd_prepare;
hd_analyze_accuracy;