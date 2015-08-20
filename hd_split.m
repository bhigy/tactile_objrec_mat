% Splitting the haptic data

if ~exist('filtered_filename', 'var') || isempty(filtered_filename)
    error('Unknownk variable "filtered_filename"');
end

% Loading data
load([root, formalized_filename]);
S = BasicSupervisedDataset(X, Y);

% Splitting data into training, validation and test sets
[test, training] = S.split(2, Dataset.SPLITMODE_ABS);
no_test = training.copy();
[training, validation] = training.split(50, Dataset.SPLITMODE_PCT);

% Saving data
save([root, splitted_filename], 'S', 'no_test', 'training', 'validation', 'test', 'objects');