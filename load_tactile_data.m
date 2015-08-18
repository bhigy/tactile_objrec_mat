addpath(genpath('/home/bhigy/dev/tactile_objrec_mat'));
init;

%% Loading the data
% infosFilename = '/home/bhigy/experiments/tactile_20150527_100000/data/imginfos/data.log';
% imginfos = Imginfos(infosFilename);
% [sequences, labels] = imginfos.get_sequences();
% sequences(1,:) = [];
% labels(1) = [];
% 
% hapticFilename = '/home/bhigy/experiments/tactile_20150527_100000/data/left_arm/data.log';
% hapticData = Datadump(hapticFilename);
% % Down-sampling
% %hapticData = hapticData.downsample(10);
% hapticData.filter(sequences);
% hapticData.X = hapticData.X(:,8:16);
% save('/home/bhigy/experiments/tactile_20150527_100000/dataset.mat', 'hapticData', 'sequences', 'labels');
load('/home/bhigy/experiments/tactile_20150527_100000/dataset.mat');
X = hapticData.X;

%% Computing the labels corresponding to the haptic data
[nb_datalines, ~] = size(hapticData.X);
[nb_sequences, ~] = size(sequences);
Y = zeros(nb_datalines, 1);
for i = 1:nb_datalines
    for j = 1:nb_sequences
        if hapticData.timestamps(i) >= sequences(j,1) && hapticData.timestamps(i) <= sequences(j,2)
            Y(i) = j;
            break;
        end
    end
end

S = BasicSupervisedDataset(X, Y);

% Computing mean and std
m = S.catMean();
s = S.catStd();

figure;
errorbar(repmat(7:15, size(m,1), 1)', m', s');
legend(labels);

% Normalizing data
Snorm = S.normalize();

m = Snorm.catMean();
s = Snorm.catStd();

figure;
errorbar(repmat(7:15, size(m,1), 1)', m', s');
legend(labels);

% Visualization
points_tsne = Snorm.get2DProjection(Dataset.METH_TSNE);
points_tsne.draw(Snorm.getY(), labels);
points_svd = Snorm.get2DProjection(Dataset.METH_SVD);
points_svd.draw(Snorm.getY(), labels);

% Distance matrix
D = L2_distance(X', X');

imagesc(D);             %# Create a colored plot of the matrix values
colormap(flipud(gray)); %# Change the colormap to gray (so higher values are
                        %#   black and lower values are white)

% Redundancy
U = unique(X);
V = arrayfun(@(x) sum(sum(bsxfun(@eq, X, U(x,:)),2) == size(U,2)), 1:size(U,1));

plot(X(:,8));
