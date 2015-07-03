addpath(genpath('/home/bhigy/dev/tactile_objrec_mat'));
init;

%% Loading all data
% dataset = VisualDataset('/home/bhigy/experiments/venerdi26/data');
% save('/home/bhigy/experiments/venerdi26/dataset.mat', 'dataset');
load('/home/bhigy/experiments/venerdi26/dataset.mat');

%% Configuration
scenario = 5;

switch scenario
    case 1
        % 1 instance x 2 labels
        samples = {'dish1' 'laundrydetergent1'};
        filter_by = VisualDataset.INSTANCE;
    case 2
        %  1 instance x all labels
        samples = {'dish1' 'laundrydetergent1' 'mug1' 'soap1' 'sponge1' 'sprinkler1' 'washingup1'};
        filter_by = VisualDataset.INSTANCE;
    case 3
        % all instances x 2 labels - clustering on instances
        samples = {'dish' 'laundrydetergent'};
        filter_by = VisualDataset.LABEL;
    case 4
        % all instances x 2 labels - clustering on labels
        samples = {'dish' 'laundrydetergent'};
        filter_by = VisualDataset.LABEL;
    case 5
        % all instances x all labels - clustering on instances
        samples = dataset.getRefInfos(VisualDataset.LABEL);
        filter_by = [];
    case 6
        % all instances x all labels - clustering on labels
        samples = dataset.getRefInfos(VisualDataset.LABEL);
        filter_by = [];
end


%% Filtering unwanted samples
if isempty(filter_by)
    S = dataset.copy();
else
    S = dataset.getSubset(dataset.check_condition(filter_by, samples));    
end

%% Preparing for clustering
switch scenario
    case 1
        % 1 instance x 2 labels
        cluster_by = VisualDataset.LABEL;
    case 2
        %  1 instance x all labels
        cluster_by = VisualDataset.LABEL;
    case 3
        % all instances x 2 labels - clustering on instances
        cluster_by = VisualDataset.INSTANCE;
    case 4
        % all instances x 2 labels - clustering on labels
        cluster_by = VisualDataset.LABEL;
    case 5
        % all instances x all labels - clustering on instances
        cluster_by = VisualDataset.INSTANCE;
    case 6
        % all instances x all labels - clustering on labels
        cluster_by = VisualDataset.LABEL;
end
switch cluster_by
    case VisualDataset.LABEL
        labels = S.getRefInfos(VisualDataset.LABEL);
        Y = S.getDataInfos(VisualDataset.LABEL);
     case VisualDataset.INSTANCE
        labels = S.getRefInfos(VisualDataset.INSTANCE);
        Y = S.getDataInfos(VisualDataset.INSTANCE);
end
labels = labels(unique(Y));