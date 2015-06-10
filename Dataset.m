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
    
    %% Methods
    methods
        function obj = Dataset(data)
            obj.data = data;
        end
        
        function subset = downsample(obj, factor)
            % Downsamples the dataset taking one line out of 'factor'
            selection = zeros(size(obj.data, 1), 1);
            selection(1:factor:end) = 1;
            subset = obj.get_subset(logical(selection));
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
        
        function subset = get_subset(obj, criteria)
            subset      = obj.copy();
            subset.data = subset.data(criteria,:);
        end
        
        function [set1, set2] = split(obj, split_value, mode)
            % Split the data based on the split_value and the split mode
            total_size = size(obj.data, 1);
            switch mode
                case Dataset.SPLITMODE_PCT
                    size1 = round(total_size * split_value / 100);
                case Dataset.SPLITMODE_ABS
                    size1 = split_value;
            end
            picked = Dataset.random_selection(size1, total_size);
            set1 = obj.get_subset(picked);
            set2 = obj.get_subset(~picked);
        end


        function set = merge_subsets(set1, set2)
            % Merge 2 subsets
            set = set1.copy();
            if ~isempty(set2)
                set.data = [set.data; set2.data];
            end
        end
        
        function [set1, set2] = split_cat(obj, split_value, mode, grouping)
            % Split the data of each category (based on 'grouping') 
            % depending on the 'split_value' and the split 'mode'
            if isempty(grouping)
                grouping = zeros(size(obj.data, 1), 1);
            end
            categories = unique(grouping);
            set1 = [];
            set2 = [];
            for i = 1:length(categories)
                subset = obj.get_subset(grouping == categories(i));
                [split1, split2] = subset.split(split_value, mode);
                set1 = split1.merge_subsets(set1);
                set2 = split2.merge_subsets(set2);
            end
        end
    end
end