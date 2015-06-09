addpath(genpath('/home/bhigy/dev/tactile_objrec_mat'));

format long

%% Loading the data
infos_filename = '/home/bhigy/data/experiments/20150527_1000/imginfos/data.log';
imginfos = Imginfos(infos_filename);
[sequences, labels] = imginfos.get_sequences();
sequences(1,:) = [];
labels(1) = [];

haptic_filename = '/home/bhigy/data/experiments/20150527_1000/left_arm/data.log';
haptic_data = Datadump(haptic_filename);
% Down-sampling
haptic_data.downsample(10);
haptic_data.filter(sequences);
haptic_data.data = haptic_data.data(:,8:16);
X = haptic_data;

%% Computing the labels corresponding to the haptic data
[nb_datalines, ~] = size(haptic_data.data);
[nb_sequences, ~] = size(sequences);
Y = zeros(1, nb_datalines);
for i = 1:nb_datalines
    for j = 1:nb_sequences
        if haptic_data.timestamps(i) >= sequences(j,1) && haptic_data.timestamps(i) <= sequences(j,2)
            Y(i) = j;
            break;
        end
    end
end