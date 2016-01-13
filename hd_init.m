function param = hd_init(datasets, set)
    % Initializing some global parameters

    % Filenames
    param.filenames.raw         = 'matlab/raw_data.mat';        % raw data filename
    param.filenames.raw_actions = 'matlab/raw_actions.mat';     % raw actions data filename

    % Columns from raw data
    param.raw_cols.analog      = 2:8;
    param.raw_cols.skin        = [2:14, 15:26, 27:38, 39:50, 51:62, 99:109, 111:121, 123:133, 135:141, 143:146];
    param.raw_cols.skin_comp   = param.raw_cols.skin;
    param.raw_cols.springy     = 2:7;
    param.raw_cols.state       = [2 11:18];
    param.raw_cols.wrench      = 2:8;
    param.raw_cols.cart_wrench = 2:10;

    % Columns for merged data
%     param.mer_cols.analog    = 1:length(param.raw_cols.analog);
%     param.mer_cols.skin      = (param.mer_cols.analog(end) + 1):(param.mer_cols.analog(end) + length(param.raw_cols.skin));
%     param.mer_cols.skin_comp = (param.mer_cols.skin(end) + 1):(param.mer_cols.skin(end) + length(param.raw_cols.skin));
%     param.mer_cols.springy   = (param.mer_cols.skin_comp(end) + 1):(param.mer_cols.skin_comp(end) + length(param.raw_cols.springy));
%     param.mer_cols.state     = (param.mer_cols.springy(end) + 1):(param.mer_cols.springy(end) + length(param.raw_cols.state));

    % Columns for the different parts of the skin
%     param.skin_col.thumb           = [cols_skin(49):cols_skin(60), cols_skin_comp(49):cols_skin_comp(60), cols_springy(1), cols_state(1):cols_state(3)];
%     param.skin_col.index           = [cols_skin(1):cols_skin(12), cols_skin_comp(1):cols_skin_comp(12), cols_springy(2), cols_state(4):cols_state(5)];
%     param.skin_col.middle          = [cols_skin(13):cols_skin(24), cols_skin_comp(13):cols_skin_comp(24), cols_springy(3), cols_state(6):cols_state(7)];
%     param.skin_col.ring_and_little = [cols_skin(25):cols_skin(36), cols_skin(37):cols_skin(48), cols_skin_comp(25):cols_skin_comp(36), cols_skin_comp(37):cols_skin_comp(48), ...
%                                          cols_springy(4), cols_springy(5), cols_state(8)];
%     param.skin_col.palm            = [cols_skin(61):cols_skin(104), cols_skin_comp(61):cols_skin_comp(104)];

    % Other params
    param.grasp_duration = 2;

    % Parameters specific to the dataset
    switch(set)
        case datasets.PRETEST
            % root folder
            param.root = '/home/bhigy/experiments/haptic_data_pretest/';
            % invalid trials to remove
            param.invalid_trials = 30;
            param.nb_items_test = 2;
        case datasets.HAPTIC1
            % root folder
            param.root = '/home/bhigy/experiments/haptic_data/';
            % invalid trials to remove
            param.invalid_trials = [25 62 75 114 149 150 202];
            param.nb_items_test = 8;
        case datasets.WEIGH
            % root folder
            param.root = '/home/bhigy/experiments/weigh_test/';
            % invalid trials to remove
            param.invalid_trials = [];
            param.nb_items_test = [];
            param.event_offset = 2;
        case datasets.HAPTIC2
            % root folder
            param.root = '/home/bhigy/experiments/haptic_data_20151021/';
            param.loading_routine = @hdl_20151021;
            % invalid trials to remove
            param.invalid_trials = [10 12 13 14 25 29 47 49 51 61 70 73 78 87 115 124 127 129 132 134 143 159 165 168 184 206 209 ...
                                    217 223 226 227 233 263 270 271 273 275 278 292 295 297 321 331 333 335 339 343 358 360 381 383 386 401 405];
            param.nb_items_test = 9;
        case datasets.HAPTIC3
            % root folder
            param.root = '/home/bhigy/experiments/haptic_data_20151028/';
            param.loading_routine = @hdl_20151028;
            % invalid trials to remove
            param.invalid_trials = [55];
            param.nb_items_test = 9;
            % rign and little finger are not working
            param.raw_cols.springy     = 2:5;
            param.raw_cols.state       = [2 11:17];
    end
end