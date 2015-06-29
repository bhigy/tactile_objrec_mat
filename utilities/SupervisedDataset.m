classdef SupervisedDataset < Dataset
    methods (Abstract)
        getY(obj)
    end
end