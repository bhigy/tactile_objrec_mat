% Loading haptic data

if ~exist('root', 'var') || isempty(root)
    error('Unknownk variable "root"');
end
if ~exist('raw_filename', 'var') || isempty(raw_filename)
    error('Unknownk variable "raw_filename"');
end


%% Loading data
labels   = load_file([root, 'dump/grasper/labels/data.log'], '%d %f %s');
events   = load_file([root, 'dump/grasper/events/data.log'], '%d %f %s %q');
analog   = load([root, 'dump/left_arm/analog/data.log']);
state    = load([root, 'dump/left_arm/state/data.log']);
springy  = load([root, 'dump/model/springy/data2.log']);
skin     = load([root, 'dump/skin/left_hand/data.log']);
skinComp = load([root, 'dump/skin/left_hand_comp/data.log']);


%% Saving data
save([root, raw_filename], 'analog', 'events', 'labels', 'skin', 'skinComp', 'springy', 'state');