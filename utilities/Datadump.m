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
                obj.data        = load(path);
                obj.timestamps  = obj.data(:,2);
                obj.data        = obj.data(:,3:end);
            else
                obj.timestamps = [];
            end
        end
        
        function obj = filter(obj, sequences)
            i_data = 1;
            [nb_lines, ~] = size(obj.data);
            [i_max_seq, ~] = size(sequences);
            for i_seq = 1:i_max_seq
                % removing lines before the sequence
                t_seq = sequences(i_seq,1);
                while i_data <= nb_lines && obj.timestamps(i_data) < t_seq
                    obj.data(i_data,:) = [];
                    obj.timestamps(i_data) = [];
                    nb_lines = nb_lines - 1;
                end
                
                % keeping lines in the sequence
                t_seq = sequences(i_seq,2);
                while i_data <= nb_lines && obj.timestamps(i_data) <= t_seq
                    i_data = i_data + 1;
                end
            end
            % removing lines after the last sequence
            obj.data(i_data:end,:) = [];
            obj.timestamps(i_data:end) = [];
        end

        function set = merge_subsets(set1, set2)
            set = set1.merge_subsets@Dataset(set2);
            if ~isempty(set2)
                set.timestamps = [set.timestamps; set2.timestamps];
            end
        end
    end
    
    %% Protected methods
    methods (Access = protected)
        function subset = get_subset_from_crit(obj, criteria)
            subset              = obj.get_subset_from_crit@Dataset(criteria);
            subset.timestamps   = obj.timestamps(criteria);
        end

        function subset = get_subset_from_linno(obj, linno)
            subset              = obj.get_subset_from_linno@Dataset(linno);
            subset.timestamps   = obj.timestamps(linno);
        end
    end
end