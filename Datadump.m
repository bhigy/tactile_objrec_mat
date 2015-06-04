classdef Datadump
    properties
        data
    end
    
    methods 
        function obj = Datadump(path)
            obj.data = load(path);
        end
        
        function obj = filter(obj, sequences)
            i_data = 1;
            [nb_lines nb_col] = size(obj.data);
            [i_max_seq j_max_seq] = size(sequences);
            for i_seq = 1:i_max_seq
                % removing lines before the sequence
                t_seq = sequences(i_seq,1);
                while i_data <= nb_lines && obj.data(i_data,2) < t_seq
                    obj.data(i_data,:) = [];
                    nb_lines = nb_lines - 1;
                end
                
                % keeping lines in the sequence
                t_seq = sequences(i_seq,2);
                while i_data <= nb_lines && obj.data(i_data,2) <= t_seq
                    i_data = i_data + 1;
                end
            end
            % removing lines after the last sequence
            obj.data(i_data:end,:) = [];
        end
    end
end