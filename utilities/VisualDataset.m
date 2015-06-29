classdef VisualDataset < SupervisedDataset
    % Visual dataset
    
    %% Properties
    properties (Constant)
        LABEL = 1
        INSTANCE = 2
        FEATURE = 3
    end
    properties %(Access = private)
        refLabels
        refInstances
        refFeatures
        labels
        instances
        features
        catCriteria
    end
    
    %% Methods
    methods
        function obj = VisualDataset(path)
            % Constructor
            
            % Initialization
            obj = obj@SupervisedDataset();
            obj.labels = [];
            obj.instances = [];
            obj.features = [];
            obj.refLabels = {};
            obj.refInstances = {};
            obj.refFeatures = {};
            obj.catCriteria = VisualDataset.INSTANCE;
            
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
            folderName = path(pos + 1:end);
            path = path(1:pos -1);
            d = Directory(path, folderName);
            sd = d.getSubDirs();

            nbLabelsIni = length(obj.labels);
            nbInstances = length(obj.instances);
            nbFeatures = length(obj.features);
            
            for i = 1:length(sd)
                obj.refLabels(i) = {sd(i).name};
                ssd = getSubDirs(sd(i));
                for j = 1:length(ssd)
                    nbInstances = nbInstances + 1;
                    obj.refInstances(nbInstances) = {ssd(j).name};
                    files = getFiles(ssd(j));
                    for k = 1:length(files)
                        nbFeatures = nbFeatures + 1;
                        obj.refFeatures(nbFeatures) = {files(k).name};
                        obj.X = [obj.X; load(files(k).fullPath)'];
                        obj.labels(end + 1, 1) = nbLabelsIni + i;
                        obj.instances(end + 1, 1) = nbInstances;
                        obj.features(end + 1, 1) = nbFeatures;
                    end
                end
            end
        end
        
        function Y = getY(obj)
            Y = obj.getDataInfos(obj.catCriteria);
        end
        
        function setCatCriteria(obj, catCriteria)
            obj.catCriteria = catCriteria;
        end
        
        function infos = getRefInfos(obj, type)
            switch type
                case VisualDataset.LABEL
                    infos = obj.refLabels;
                case VisualDataset.INSTANCE
                    infos = obj.refInstances;
                case VisualDataset.FEATURE
                    infos = obj.refFeatures;
            end
        end
        
        function dataInfos = getDataInfos(obj, type)
            switch type
                case VisualDataset.LABEL
                    dataInfos = obj.labels;
                case VisualDataset.INSTANCE
                    dataInfos = obj.instances;
                case VisualDataset.FEATURE
                    dataInfos = obj.features;
            end
        end
        
        function isVerified = checkCondition(obj, column, allowedValues)
            refValues = obj.getRefInfos(column);
            dataValues = obj.getDataInfos(column);
            
            ids = [];
            for i = 1:length(allowedValues)
                ids = [ids find(strcmp(allowedValues(i), refValues))];
            end
            isVerified = ismember(dataValues, ids);
        end
        
        function set = mergeSubsets(set1, set2)
            set = set1.mergeSubsets@Dataset(set2);
            if ~isempty(set2)
                set.labels     = [set.labels; set2.labels];
                set.instances  = [set.instances; set2.instances];
                set.features   = [set.features; set2.features];
            end
        end
    end
    
    %% Protected methods
    methods (Access = protected)
        function subset = getSubsetFromCrit(obj, criteria)
            subset = obj.getSubsetFromCrit@Dataset(criteria);
            subset.labels = obj.labels(criteria);
            subset.instances = obj.instances(criteria);
            subset.features = obj.features(criteria);
            subset.refLabels = obj.refLabels;
            subset.refInstances = obj.refInstances;
            subset.refFeatures = obj.refFeatures;
        end
        
        function subset = getSubsetFromLinno(obj, linno)
            subset = obj.getSubsetFromLinno@Dataset(linno);
            subset.labels = obj.labels(linno);
            subset.instances = obj.instances(linno);
            subset.features = obj.features(linno);
            subset.refLabels = obj.refLabels;
            subset.refInstances = obj.refInstances;
            subset.refFeatures = obj.refFeatures;
        end
    end
end