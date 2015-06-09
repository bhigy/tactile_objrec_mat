addpath(genpath('/home/bhigy/dev/tactile_objrec_mat'));

%% Loading all data
dataset = VisualDataset('/home/bhigy/data/venerdi26');

%% Configuration
config = 1;

switch config
    case 1
        % 1 instance x 2 labels
        samples = {'dish1' 'laundrydetergent1'};
        filter_by = VisualDataset.INSTANCE;
        cluster_by = VisualDataset.LABEL;
    case 2
        %  1 instance x all labels
        samples = {'dish1' 'laundrydetergent1' 'mug1' 'soap1' 'sponge1' 'sprinkler1' 'washingup1'};
        filter_by = VisualDataset.INSTANCE;
        cluster_by = VisualDataset.LABEL;
        col_clustering = 1;
    case 3
        % all instances x 2 labels - clustering on instances
        samples = {'dish' 'laundrydetergent'};
        filter_by = VisualDataset.LABEL;
        cluster_by = VisualDataset.INSTANCE;
    case 4
        % all instances x 2 labels - clustering on labels
        samples = {'dish' 'laundrydetergent'};
        filter_by = VisualDataset.LABEL;
        cluster_by = VisualDataset.LABEL;
        k = length(samples);
    case 5
        % all instances x all labels - clustering on instances
        samples = dataset.get_ref_infos(VisualDataset.LABEL);
        filter_by = [];
        cluster_by = VisualDataset.INSTANCE;
    case 6
        % all instances x all labels - clustering on labels
        samples = dataset.get_ref_infos(VisualDataset.LABEL);
        filter_by = [];
        cluster_by = VisualDataset.LABEL;
end


%% Filtering unwanted samples
if isempty(filter_by)
    X = dataset.copy();
else
    X = dataset.get_subset(dataset.check_condition(filter_by, samples));    
end

switch cluster_by
    case VisualDataset.LABEL
        labels = X.get_ref_infos(VisualDataset.LABEL);
        Y = X.get_data_infos(VisualDataset.LABEL);
     case VisualDataset.INSTANCE
        labels = X.get_ref_infos(VisualDataset.INSTANCE);
        Y = X.get_data_infos(VisualDataset.INSTANCE);
end
labels = labels(unique(Y));