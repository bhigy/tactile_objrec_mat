classdef VisualDataset < matlab.mixin.Copyable
    properties (Constant)
        LABEL = 1
        INSTANCE = 2
        FEATURE = 3
    end
    properties
        data
    end
    properties (Access = private)
        ref_labels
        ref_instances
        ref_features
        data_labels
        data_instances
        data_features
    end
    
    methods
        function obj = VisualDataset(path)
            pos = strfind(path, '/');
            pos = pos(end);
            folder_name = path(pos + 1:end);
            path = path(1:pos -1);
            d = Directory(path, folder_name);
            sd = d.get_sub_dirs();

            obj.data = [];
            obj.data_labels = [];
            obj.data_instances = [];
            obj.data_features = [];
            obj.ref_labels = {};
            obj.ref_instances = {};
            obj.ref_features = {};
            nb_instances = 0;
            nb_features = 0;
            
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
                        obj.data_labels(end + 1) = i;
                        obj.data_instances(end + 1) = nb_instances;
                        obj.data_features(end + 1) = nb_features;
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
                    data_infos = obj.data_labels;
                case VisualDataset.INSTANCE
                    data_infos = obj.data_instances;
                case VisualDataset.FEATURE
                    data_infos = obj.data_features;
            end
        end
        
        function filter(obj, by, allowed_values)
            ref_values = obj.get_ref_infos(by);
            data_values = obj.get_data_infos(by);
            
            ids = [];
            for i = 1:length(allowed_values)
                ids = [ids find(strcmp(allowed_values(i), ref_values))];
            end
            lines = ismember(data_values, ids);
            obj.data = obj.data(lines,:);
        end
    end
end