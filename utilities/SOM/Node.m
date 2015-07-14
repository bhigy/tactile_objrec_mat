classdef Node < matlab.mixin.Copyable
    properties
        weights
    end
    
    methods
        function obj = Node(a, b, c)
            if nargin <= 1
                if exist('a', 'var') && ~isempty(a)
                    obj.weights = rand(a, 1);
                end
            elseif nargin <= 3
                if ~exist('c', 'var')
                    c = [];
                end
                obj(a,b) = Node(c);
                for i = 1:a
                   for j = 1:b
                      obj(i,j).resize(c);
                   end
                end
            end
        end
        
        function resize(obj, dim)
            obj.weights = rand(dim, 1);
        end
    end
end