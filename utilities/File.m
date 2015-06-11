classdef File < Pathname
    methods
        function obj = File(path, name)
            obj@Pathname(path, name);
        end
    end
end