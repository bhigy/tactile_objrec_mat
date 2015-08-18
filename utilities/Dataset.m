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
        X
    end
    
    %% Static methods
    methods (Static)
        function selection = selectRandom(m, n)
            % Returns a vector of size n, with m '1' choosen randomly and 
            % everything else being '0'
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
        function selection = splitSelection(size, splitValue, mode)
            % Select elements from a set of size 'size', based on
            % splitValue and mode
            switch mode
                case Dataset.SPLITMODE_PCT
                    sizeSub = round(size * splitValue / 100);
                case Dataset.SPLITMODE_ABS
                    sizeSub = splitValue;
            end
            selection = Dataset.selectRandom(sizeSub, size);
        end
    end
    
    %% Public methods
    methods
        function obj = Dataset(X)
            if ~exist('X', 'var')
                obj.X = [];
            else
                obj.X = X;
            end
        end
        
        function newObj = new(obj)
            newObj = eval(class(obj));
        end
        
        function subset = downsample(obj, factor)
            % Downsamples the dataset taking one line out of 'factor'
            selection = zeros(size(obj.X, 1), 1);
            selection(1:factor:end) = 1;
            subset = obj.getSubsetFromCrit(logical(selection));
        end
        
        function points = get2DProjection(obj, projMeth, perplexity)
            switch projMeth
                case Dataset.METH_SVD
                    [U, S, ~] = svd(obj.X);
                    proj = U*S;
                    points = Points(proj(:,1), proj(:,2));
                case Dataset.METH_TSNE
                    if exist('perplexity', 'var') && ~isempty(perplexity)
                        proj = fast_tsne(obj.X, [], [], perplexity);
                    else
                        proj = fast_tsne(obj.X);
                    end
                    points = Points(proj(:,1), proj(:,2));
            end
        end
        
        function subset = getSubset(obj, arg)
            switch class(arg)
                case 'logical'
                    subset = obj.getSubsetFromCrit(arg);
                case 'double'
                    subset = obj.getSubsetFromLinno(arg);
                otherwise
                    error('Invalid argument');
            end
        end
        
        function set = mergeSubsets(set1, set2)
            % Merge 2 subsets
            set = set1.copy();
            if ~isempty(set2)
                set.X = [set.X; set2.X];
            end
        end
        
        function [set1, set2] = split(obj, splitValue, mode, grouping)
            % Split the data of each category (based on 'grouping') 
            % depending on the 'splitValue' and the split 'mode'
            if ~exist('grouping', 'var') || isempty(grouping)
                selection = Dataset.splitSelection(size(obj.X, 1), splitValue, mode);
                set1 = obj.X(selection,:);
                set2 = obj.X(~selection,:);
            else
                categories = unique(grouping);
                indices1 = [];
                indices2 = [];
                for i = 1:length(categories)
                    indices = find(grouping == categories(i));
                    selection = Dataset.splitSelection(length(indices), splitValue, mode);
                    indices1 = [indices1; indices(selection)];
                    indices2 = [indices2; indices(~selection)];
                end
                set1 = obj.getSubsetFromLinno(indices1);
                set2 = obj.getSubsetFromLinno(indices2);
            end
        end
        
        function N = normalize(obj)
            N = obj.copy;
            m = mean(N.X);
            s = std(N.X);
            for i = 1:size(N.X,1)
                N.X(i,:) = (N.X(i,:) - m) ./ s;
            end
        end
        
        function N = centralize(obj)
            N = obj.copy;
            m = mean(N.X);
            s = std(N.X);
            for i = 1:size(N.X,1)
                N.X(i,:) = (N.X(i,:) - m);
            end
        end
    end
    
    %% Protected methods
    methods (Access = protected)
        function subset = getSubsetFromCrit(obj, criteria)
            subset      = obj.new();
            subset.X = obj.X(criteria,:);
        end
        
        function subset = getSubsetFromLinno(obj, linno)
            subset      = obj.new();
            subset.X = obj.X(linno,:);
        end
    end
end