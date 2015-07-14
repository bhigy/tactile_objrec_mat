classdef Map < matlab.mixin.Copyable
    properties
        width
        height
        dim
        nodes
    end
    
    methods
        function obj = Map(w, h, dim)
            obj.width = w;
            obj.height = h;
            obj.dim = dim;
            obj.nodes = Node(w, h, dim); 
        end
        
        function [x, y] = bum(obj, v)
            minDist = Inf;
            x = 0;
            y = 0;
            for i = 1:obj.width
                for j = 1:obj.height
                    dist = norm(obj.nodes(i,j).weights - v);
                    if dist < minDist
                        x = i;
                        y = j;
                        minDist = dist;
                    end
                end
            end
        end
        
        function train(obj, I, nbIter, l0)
            if ~exist('l0', 'var') || isempty(l0)
                l0 = 0.1;
            end
            
            r0 = max(obj.width, obj.height) / 2;
            lambda = nbIter / log(r0);
            
            for iter = 1:nbIter
                v = I(randi(size(I, 1)),:)';
                [x, y] = obj.bum(v);
                obj.update(x, y, iter, r0, l0, lambda, v)
            end
        end
        
        function M = get3D(obj)
            M = zeros(obj.width, obj.height, obj.dim);
            for i = 1:obj.width
                for j = 1:obj.height
                    M(i,j,:) = obj.nodes(i,j).weights;
                end
            end
        end
    end
    
    methods(Access = protected)
        function update(obj, x, y, iter, r0, l0, lambda, v)
            rt = r0 * exp(-iter / lambda);
            lt = l0 * exp(-iter / lambda);
            range_i = max(1, ceil(x-rt)):min(obj.width, floor(x+rt));
            range_j = max(1, ceil(y-rt)):min(obj.height, floor(y+rt));
            for i = range_i
                for j = range_j
                    if (x - i)^2 + (y - j)^2 < rt^2
                        node = obj.nodes(i,j).weights;
                        diff = v - node;
                        dist = norm(diff);
                        g = exp(-dist / (2 * rt^2));
                        obj.nodes(i,j).weights = node + g * lt * diff;
                    end
                end
            end
        end
    end
end