function data = hd_load(root)
    % Loading haptic data

    if ~exist('root', 'var') || isempty(root)
        error('Unknownk variable "root"');
    end

    %% Loading data
    data.labels      = load_file([root, 'grasper/labels/data.log'], '%d %f %s');
    data.events      = load_file([root, 'grasper/events/data.log'], '%d %f %s %q');
    data.analog      = load([root, 'left_arm/analog/data.log']);
    data.state       = load([root, 'left_arm/state/data.log']);
    data.springy     = load([root, 'model/springy/data.log']);
    data.skin        = load([root, 'skin/left_hand/data.log']);
    data.skin_comp   = load([root, 'skin/left_hand_comp/data.log']);
    data.wrench      = load([root, 'wbd/endEffectorWrench/data.log']);
    data.cart_wrench = load([root, 'wbd/cartesianEndEffectorWrench/data.log']);
end

