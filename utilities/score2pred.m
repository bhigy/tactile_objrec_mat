function Y = score2pred(model, scores)
%SCORE2PRED Converts GURLS scores into a predicted category

if isa(model, 'GurlsOptions')
   if isfield(model.setting, 'yformat')
        switch model.setting.yformat
            case 'compact-twoclass'
                z = min(model.setting.labeldict)*ones(size(scores,1),1);
                z(scores>=0) = max(model.setting.labeldict);
                Y = z;
            case 'compact-multiclass'
                [~, yp] = max(scores,[], 2);
                ind = model.setting.labeldict;
                Y = zeros(numel(yp),1);
                for i=1:size(ind)
                    Y(yp==i) = ind(i);
                end
        end
   end
else
    error('''model'' should be of type GurlsOptions');
end

end