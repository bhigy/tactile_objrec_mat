classdef VisualDataset < Dataset
    % Visual dataset
    
    %% Properties
    properties (Constant)
        LABEL = 1
        INSTANCE = 2
        FEATURE = 3
    end
    properties %(Access = private)
        ref_labels
        ref_instances
        ref_features
        labels
        instances
        features
    end
    
    %% Methods
    methods
        function obj = VisualDataset(path)
            % Constructor
            
            % Initialization
            obj = obj@Dataset();
            obj.labels = [];
            obj.instances = [];
            obj.features = [];
            obj.ref_labels = {};
            obj.ref_instances = {};
            obj.ref_features = {};
            
            if exist('path', 'var')
                obj.load(path);
            end
        end
        
        function load(obj, path)
            if ~exist('path', 'var') || isempty(path)
                error('Please specify a path');
            end
            
            pos = strfind(path, '/');
            pos = pos(end);
            folder_name = path(pos + 1:end);
            path = path(1:pos -1);
            d = Directory(path, folder_name);
            sd = d.get_sub_dirs();

            nb_labels_ini = length(obj.labels);
            nb_instances = length(obj.instances);
            nb_features = length(obj.features);
            
            for i = 1:length(sd)
                obj.ref_labels(i) = {sd(i).name};
                ssd = get_sub_dirs(sd(i));
                for j = 1:length(ssd)
                    nb_instances = nb_instances + 1;
                    obj.ref_instances(nb_instances) = {ssd(j).name};
                    files = get_files(ssd(j));
                    for k = 1:length(files)
                        nb_features = nb_features + 1;
                        obj.ref_features(nb_features) = {files(k).name};
                        obj.data = [obj.data; load(files(k).full_path)'];
                        obj.labels(end + 1, 1) = nb_labels_ini + i;
                        obj.instances(end + 1, 1) = nb_instances;
                        obj.features(end + 1, 1) = nb_features;
                    end
                end
            end
        end
        
        function infos = get_ref_infos(obj, type)
            switch type
                case VisualDataset.LABEL
                    infos = obj.ref_labels;
                case VisualDataset.INSTANCE
                    infos = obj.ref_instances;
                case VisualDataset.FEATURE
                    infos = obj.ref_features;
            end
        end
        
        function data_infos = get_data_infos(obj, type)
            switch type
                case VisualDataset.LABEL
                    data_infos = obj.labels;
                case VisualDataset.INSTANCE
                    data_infos = obj.instances;
                case VisualDataset.FEATURE
                    data_infos = obj.features;
            end
        end
        
        function is_verified = check_condition(obj, column, allowed_values)
            ref_values = obj.get_ref_infos(column);
            data_values = obj.get_data_infos(column);
            
            ids = [];
            for i = 1:length(allowed_values)
                ids = [ids find(strcmp(allowed_values(i), ref_values))];
            end
            is_verified = ismember(data_values, ids);
        end
        
        function set = merge_subsets(set1, set2)
            set = set1.merge_subsets@Dataset(set2);
            if ~isempty(set2)
                set.labels     = [set.labels; set2.labels];
                set.instances  = [set.instances; set2.instances];
                set.features   = [set.features; set2.features];
            end
        end
    end
    
    %% Protected methods
    methods (Access = protected)
        function subset = get_subset_from_crit(obj, criteria)
            subset = obj.get_subset_from_crit@Dataset(criteria);
            subset.labels = obj.labels(criteria);
            subset.instances = obj.instances(criteria);
            subset.features = obj.features(criteria);
            subset.ref_labels = obj.ref_labels;
            subset.ref_instances = obj.ref_instances;
            subset.ref_features = obj.ref_features;
        end
        
        function subset = get_subset_from_linno(obj, linno)
            subset = obj.get_subset_from_linno@Dataset(linno);
            subset.labels = obj.labels(linno);
            subset.instances = obj.instances(linno);
            subset.features = obj.features(linno);
            subset.ref_labels = obj.ref_labels;
            subset.ref_instances = obj.ref_instances;
            subset.ref_features = obj.ref_features;
        end
    end
end