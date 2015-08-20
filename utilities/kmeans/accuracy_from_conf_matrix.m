function [accuracy] = accuracy_from_conf_matrix(confusion_matrix)
% Compute the overall accuracy from the confusion matrix

    accuracy = mean(arrayfun(@(x) confusion_matrix(x,x)/sum(confusion_matrix(x,:)), 1:size(confusion_matrix, 1)));

end

