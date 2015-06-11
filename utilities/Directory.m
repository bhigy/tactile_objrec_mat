classdef Directory < Pathname
    methods
        function obj = Directory(path, name)
            obj@Pathname(path, name);
        end
        
        function subdirs = get_sub_dirs(obj)
            sd = dir(obj.full_path);
            sd = sd([sd(:).isdir]);
            sd = sd(~ismember({sd(:).name},{'.','..'}));
            subdirs = [];
            for i = 1:length(sd)
                subdirs = [subdirs; Directory(obj.full_path, sd(i).name)];
            end
        end
        
        function files = get_files(obj)
            f = dir(obj.full_path);
            f = f(~[f(:).isdir]);
            files = [];
            for i = 1:length(f)
                files = [files; File(obj.full_path, f(i).name)];
            end
        end
    end
end