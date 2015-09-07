classdef ASupervisedDataset < Dataset
    methods (Abstract)
        getY(obj)
        removeCat(obj, c)
    end
    
    methods
        function [set1, set2] = split(obj, splitValue, mode, grouping)
             if ~exist('grouping', 'var')
                 grouping = obj.getY();
             end
             [set1, set2] = obj.split@Dataset(splitValue, mode, grouping);
        end
        
        function m = catMean(obj)
            Y = obj.getY();
            d = size(obj.X,2);
            m = zeros(length(unique(Y)), d);
            for i = 1:length(unique(Y))
                m(i,:) = mean(obj.X(Y==i,:));
            end
        end
        
        function s = catStd(obj)
            Y = obj.getY();
            d = size(obj.X,2);
            s = zeros(length(unique(Y)), d);
            for i = 1:length(unique(Y))
                s(i,:) = std(obj.X(Y==i,:));
            end
        end
    end
end