classdef BasicSupervisedDataset < ASupervisedDataset
    % Basic supervised dataset
    
    %% Properties
    properties %(Access = private)
        Y
    end
    
    %% Methods
    methods
        function obj = BasicSupervisedDataset(X, Y)
            % Constructor
            
            % Initialization
            obj = obj@ASupervisedDataset();
            
            if ~exist('X', 'var')
                obj.X = [];
            else
                obj.X = X;
            end
            
            if ~exist('Y', 'var')
                obj.Y = [];
            else
                obj.Y = Y;
            end
        end
        
        function Y = getY(obj)
            Y = obj.Y;
        end
        
        function removeCat(obj, c)
            lines = find(obj.Y == c);
            obj.Y(lines, :) = [];
            obj.X(lines, :) = [];
        end
        
        function set = mergeSubsets(set1, set2)
            set = set1.mergeSubsets@SupervisedDataset(set2);
            if ~isempty(set2)
                set.Y     = [set.Y; set2.Y];
            end
        end
    end
    
    %% Protected methods
    methods (Access = protected)
        function subset = getSubsetFromCrit(obj, criteria)
            subset = obj.getSubsetFromCrit@ASupervisedDataset(criteria);
            subset.Y = obj.Y(criteria);
        end
        
        function subset = getSubsetFromLinno(obj, linno)
            subset = obj.getSubsetFromLinno@ASupervisedDataset(linno);
            subset.Y = obj.Y(linno);
        end
    end
end