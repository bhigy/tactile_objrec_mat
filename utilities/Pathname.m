classdef Pathname
    properties
        path
        name
        fullPath
    end
    
    methods
        function obj = Pathname(path, name)
            if path(end) == '/'
                obj.path = path;
            else
                obj.path = strcat(path, '/');
            end
            obj.name = name;
        end
        
        function fullPath = get.fullPath(obj)
            fullPath = strcat(obj.path, obj.name);
        end
    end
end