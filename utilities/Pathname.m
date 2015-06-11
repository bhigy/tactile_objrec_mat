classdef Pathname
    properties
        path
        name
        full_path
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
        
        function full_path = get.full_path(obj)
            full_path = strcat(obj.path, obj.name);
        end
    end
end