classdef Imginfos
    properties
        timestamps
        labels
    end
    
    methods 
        function obj = Imginfos(path)
            [a obj.timestamps c d e obj.labels] = textread(path,'%f %f %f %f %f %s');
        end
        
        function [sequences labels] = get_sequences(obj)
            [ranges labels] = get_ranges(obj.labels);
            sequences = [obj.timestamps(ranges(:,1)') obj.timestamps(ranges(:,2)')];
        end
    end
end