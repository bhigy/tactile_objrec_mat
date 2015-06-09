classdef Datadump < Dataset
    properties
        timestamps
    end
    
    methods 
        function obj = Datadump(path)
            obj.data = load(path);
            obj.timestamps = obj.data(:,2);
            obj.data = obj.data(:,3:end);
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
        
        function subset = get_subset(obj, criteria)
            subset              = obj.get_subset@Dataset(criteria);
            subset.timestamps   = subset.timestamps(criteria);
        end

        function set = merge_subsets(set1, set2)
            set = set1.merge_subsets@Dataset(set2);
            if ~isempty(set2)
                set.timestamps = [set.timestamps; set2.timestamps];
            end
        end
    end
end