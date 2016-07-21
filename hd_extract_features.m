function [X, conditions] = hd_extract_features(data, actions, modalities, features, param)
%HD_EXTRACT_FEATURES Extract features

X = cell(length(actions) * length(modalities), 1);
conditions = cell(length(X), 3);
if ismember('snapshot', features)
    t_snapshot = data.grasp.t_end - param.grasp_duration / 2;
end

i = 1;
for i_act = 1:length(actions)
    for i_mod = 1:numel(modalities)
        if ~isempty(data.(actions{i_act}).(modalities{i_mod}))
            cols = 2:size(data.(actions{i_act}).(modalities{i_mod}){1}, 2);
            if ismember('snapshot', features)
                X{i} = hdf_snapshot(data.(actions{i_act}).(modalities{i_mod}), t_snapshot, cols);
                conditions{i, 1} = actions{i_act};
                conditions{i, 2} = modalities{i_mod};
                conditions{i, 3} = 'snapshot';
                i = i + 1;
            end
            if ismember('fourier', features)
                X{i} = hdf_fourier(hd_extract_col(data.(actions{i_act}).(modalities{i_mod}), cols));
                conditions{i, 1} = actions{i_act};
                conditions{i, 2} = modalities{i_mod};
                conditions{i, 3} = 'fourier';
                i = i + 1;
            end
        end
    end
end

end