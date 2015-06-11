classdef Dataset < matlab.mixin.Copyable
    % Data container
    
    %% Constants
    properties (Constant)
        METH_SVD = 1
        METH_TSNE = 2
        SPLITMODE_PCT = 1 % split based on a percentage or ratio
        SPLITMODE_ABS = 2 % split based on an absolute number of items
    end
    
    %% Members
    properties
        data
    end
    
    %% Static methods
    methods (Static)
        function selection = random_selection(m, n)
            % Returns a vector of size n, with m '1' and everything else
            % being '0'
            selection = zeros(n, 1);
            for i = 1:m
                line = ceil(rand()*n);
                while selection(line) == 1
                    line = ceil(rand()*n);
                end
                selection(line) = 1;
            end
            selection = logical(selection);
        end
    end
    
    methods (Static, Access = protected)
        function selection = split_selection(size, split_value, mode)
            % Select elements from a set of size 'size', based on
            % split_value and mode
            switch mode
                case Dataset.SPLITMODE_PCT
                    size_sub = round(size * split_value / 100);
                case Dataset.SPLITMODE_ABS
                    size_sub = split_value;
            end
            selection = Dataset.random_selection(size_sub, size);
        end
    end
    
    %% Public methods
    methods
        function obj = Dataset(data)
             if ~exist('data', 'var')
                 data = [];
             end
            obj.data = data;
        end
        
        function new_obj = new(obj)
            new_obj = eval(class(obj));
        end
        
        function subset = downsample(obj, factor)
            % Downsamples the dataset taking one line out of 'factor'
            selection = zeros(size(obj.data, 1), 1);
            selection(1:factor:end) = 1;
            subset = obj.get_subset_from_crit(logical(selection));
        end
        
        function points = get_2D_projection(obj, proj_meth)
            switch proj_meth
                case Dataset.METH_SVD
                    [U, S, ~] = svd(obj.data);
                    proj = U*S;
                    points = Points(proj(:,1), proj(:,2));
                case Dataset.METH_TSNE
                    proj = fast_tsne(obj.data);
                    points = Points(proj(:,1), proj(:,2));
            end
        end
        
        function subset = get_subset(obj, arg)
            switch class(arg)
                case 'logical'
                    subset = obj.get_subset_from_crit(arg);
                case 'double'
                    subset = obj.get_subset_from_linno(arg);
                otherwise
                    error('Invalid argument');
            end
        end
        
        function set = merge_subsets(set1, set2)
            % Merge 2 subsets
            set = set1.copy();
            if ~isempty(set2)
                set.data = [set.data; set2.data];
            end
        end
        
%         function [set1, set2] = split(obj, split_value, mode)
%             % Split the data based on the split_value and the split mode
%             total_size = size(obj.data, 1);
%             switch mode
%                 case Dataset.SPLITMODE_PCT
%                     size1 = round(total_size * split_value / 100);
%                 case Dataset.SPLITMODE_ABS
%                     size1 = split_value;
%             end
%             picked = Dataset.random_selection(size1, total_size);
%             set1 = obj.get_subset(picked);
%             set2 = obj.get_subset(~picked);
%         end
        
        function [set1, set2] = split(obj, split_value, mode, grouping)
            % Split the data of each category (based on 'grouping') 
            % depending on the 'split_value' and the split 'mode'
            if isempty(grouping)
                selection = Dataset.split_selection(size(obj.data, 1), split_value, mode);
                set1 = obj.data(selection,:);
                set2 = obj.data(~selection,:);
            else
                categories = unique(grouping);
                indices1 = [];
                indices2 = [];
                for i = 1:length(categories)
                    indices = find(grouping == categories(i));
                    selection = Dataset.split_selection(length(indices), split_value, mode);
                    indices1 = [indices1; indices(selection)];
                    indices2 = [indices2; indices(~selection)];
                end
                set1 = obj.get_subset_from_linno(indices1);
                set2 = obj.get_subset_from_linno(indices2);
            end
        end
    end
    
    %% Protected methods
    methods (Access = protected)
        function subset = get_subset_from_crit(obj, criteria)
            subset      = obj.new();
            subset.data = obj.data(criteria,:);
        end
        
        function subset = get_subset_from_linno(obj, linno)
            subset      = obj.new();
            subset.data = obj.data(linno,:);
        end
    end
end