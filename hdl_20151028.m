function data = hdl_20151028(root)
    % Loading haptic data

    if ~exist('root', 'var') || isempty(root)
        error('Unknownk variable "root"');
    end
    
    dump{1} = [root, 'dump_20151028/'];
    dump{2} = [root, 'dump_20151029/'];
    dump{3} = [root, 'dump_20151030/'];
    
    data.labels      = cell(1, 3);
    data.events      = cell(1, 4);
    data.analog      = [];
    data.state       = [];
    data.springy     = [];
    data.skin        = [];
    data.skin_comp   = [];
    data.wrench      = [];
    data.cart_wrench = [];
%     delta1 = [0.1, 0.2, 0.2];

    % Loading
    for i = 1:length(dump)
        labels = load_file([dump{i}, 'grasper/labels/data.log'], '%d %f %s');
        for j = 1:length(labels)
            data.labels{j} = [data.labels{j}; labels{j}];
        end
        
        events = load_file([dump{i}, 'grasper/events/data.log'], '%d %f %s %q');
        for j = 1:length(events)
            data.events{j} = [data.events{j}; events{j}];
        end
        
        analog      = load([dump{i}, 'right_arm/analog/data.log']);
        state       = load([dump{i}, 'right_arm/state/data.log']);
        springy     = load([dump{i}, 'model/springy/data.log']);
        wrench      = load([dump{i}, 'wbd/endEffectorWrench/data.log']);
        cart_wrench = load([dump{i}, 'wbd/cartesianEndEffectorWrench/data.log']);
        
        t1 = mean([analog(1, 2), state(1, 2)]);
        t2 = mean([springy(1, 2), wrench(1, 2), cart_wrench(1, 2)]);
        delta2 = t1 - t2;% + delta1(i);
        analog(:,2) = analog(:,2) - delta2;
        state(:,2) = state(:,2) - delta2;
%         springy(:,2) = springy(:,2) - delta1(i);
%         wrench(:,2) = wrench(:,2) - delta1(i);
%         cart_wrench(:,2) = cart_wrench(:,2) - delta1(i);
        
        data.analog      = [data.analog; analog];
        data.state       = [data.state; state];
        data.springy     = [data.springy; springy];
        data.wrench      = [data.wrench; wrench];
        data.cart_wrench = [data.cart_wrench; cart_wrench];
    end
    
    % Filtering
    to_skip = find(strcmp(data.labels{3}, 'skip'));
    to_skip = [to_skip; (to_skip - 1)];
    data.labels = erase(data.labels, to_skip);
    to_skip = find(strcmp(data.labels{3}, 'bigb'));
    data.labels = erase(data.labels, to_skip);
end