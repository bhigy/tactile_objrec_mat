classdef Directory < Pathname
    methods
        function obj = Directory(path, name)
            obj@Pathname(path, name);
        end
        
        function subdirs = getSubDirs(obj)
            sd = dir(obj.fullPath);
            sd = sd([sd(:).isdir]);
            sd = sd(~ismember({sd(:).name},{'.','..'}));
            subdirs = [];
            for i = 1:length(sd)
                subdirs = [subdirs; Directory(obj.fullPath, sd(i).name)];
            end
        end
        
        function files = getFiles(obj)
            f = dir(obj.fullPath);
            f = f(~[f(:).isdir]);
            files = [];
            for i = 1:length(f)
                files = [files; File(obj.fullPath, f(i).name)];
            end
        end
    end
end