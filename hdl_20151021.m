function data = hdl_20151021(root)
    % Loading haptic data for the dataset from 21/10/2015

    if ~exist('root', 'var') || isempty(root)
        error('Unknownk variable "root"');
    end
    
    dump = [root, 'dump/'];

    %% Loading data
    data.labels      = load_file([dump, 'grasper/labels/data.log'], '%d %f %s');
    data.events      = load_file([dump, 'grasper/events/data.log'], '%d %f %s %q');
    data.analog      = load([dump, 'left_arm/analog/data.log']);
    data.state       = load([dump, 'left_arm/state/data.log']);
    data.springy     = load([dump, 'model/springy/data.log']);
    data.skin        = load([dump, 'skin/left_hand/data.log']);
    data.skin_comp   = load([dump, 'skin/left_hand_comp/data.log']);
    data.wrench      = load([dump, 'wbd/endEffectorWrench/data.log']);
    data.cart_wrench = load([dump, 'wbd/cartesianEndEffectorWrench/data.log']);
end

