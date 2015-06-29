classdef Datadump < Dataset
    % Datadump
    
    %% Prperties
    properties
        timestamps
    end
    
    %% Public methods
    methods 
        function obj = Datadump(path)
            obj = obj@Dataset();
            if exist('path', 'var') && ~isempty(path)
                obj.X        = load(path);
                obj.timestamps  = obj.X(:,2);
                obj.X        = obj.X(:,3:end);
            else
                obj.timestamps = [];
            end
        end
        
        function obj = filter(obj, sequences)
            i = 1;
            [nbLines, ~] = size(obj.X);
            [iSeqMax, ~] = size(sequences);
            for iSeq = 1:iSeqMax
                % removing lines before the sequence
                tSeq = sequences(iSeq,1);
                while i <= nbLines && obj.timestamps(i) < tSeq
                    obj.X(i,:) = [];
                    obj.timestamps(i) = [];
                    nbLines = nbLines - 1;
                end
                
                % keeping lines in the sequence
                tSeq = sequences(iSeq,2);
                while i <= nbLines && obj.timestamps(i) <= tSeq
                    i = i + 1;
                end
            end
            % removing lines after the last sequence
            obj.X(i:end,:) = [];
            obj.timestamps(i:end) = [];
        end

        function set = mergeSubsets(set1, set2)
            set = set1.mergeSubsets@Dataset(set2);
            if ~isempty(set2)
                set.timestamps = [set.timestamps; set2.timestamps];
            end
        end
    end
    
    %% Protected methods
    methods (Access = protected)
        function subset = getSubsetFromCrit(obj, criteria)
            subset              = obj.getSubsetFromCrit@Dataset(criteria);
            subset.timestamps   = obj.timestamps(criteria);
        end

        function subset = getSubsetFromLinno(obj, linno)
            subset              = obj.getSubsetFromLinno@Dataset(linno);
            subset.timestamps   = obj.timestamps(linno);
        end
    end
end