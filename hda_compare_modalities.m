% Haptic data analysis - Comparing modalities
addpath(genpath('/home/bhigy/dev/tactile_objrec_mat'));
init;


%% Parameters
SET_PRETEST = 1;

set = SET_PRETEST;  % set to be used

hd_init;


%% Computing accuracy for different modalities
disp('-- Analog data');
use_finger = [1 0 1 0];
use_data   = [1 0 0 0 0];
hd_prepare;
hd_analyze_accuracy;

disp('-- Skin data');
use_finger = [1 0 1 0];
use_data   = [0 1 0 0 0];
hd_prepare;
hd_analyze_accuracy;

disp('-- Skin comp data');
use_finger = [1 0 1 0];
use_data   = [0 0 1 0 0];
hd_prepare;
hd_analyze_accuracy;

disp('-- Springy data');
use_finger = [1 0 1 0];
use_data   = [0 0 0 1 0];
hd_prepare;
hd_analyze_accuracy;

disp('-- State data');
use_finger = [1 0 1 0];
use_data   = [0 0 0 0 1];
hd_prepare;
hd_analyze_accuracy;

disp('-- All data (except skin)');
use_finger = [1 0 1 0];
use_data   = [1 0 1 1 1];
hd_prepare;
hd_analyze_accuracy;
