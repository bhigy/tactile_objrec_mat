fields = {'analog', 'state', 'wrench', 'springy', 'cart_wrench'};
fields = {'wrench'};
trial_range = [1:length(grasp.analog)];
colors = linspecer(length(trial_range));
h = [];
for i_mod = 1:numel(fields)
    figure;
    hold on;
    for i_trial = 1:length(trial_range)
        
        X = grasp.(fields{i_mod}){trial_range(i_trial)}(:, 1); X = X - X(1);
        Y = grasp.(fields{i_mod}){trial_range(i_trial)}(:, 3:end);
        h(i_trial) = plot(X, grasp.(fields{i_mod}){trial_range(i_trial)}(:, 2), 'Color', colors(i_trial, :), 'DisplayName', num2str(trial_range(i_trial)));
        plot(repmat(X,1,size(Y,2)),Y, 'Color', colors(i_trial, :));
        
%         plot(grasp.(fields{i_mod}){trial_range(i_trial)}(:, 2:end), 'Color', [1 / length(trial_range) * i_trial, 0, 0]);
    end
    legend(h);
    hold off;
end
% 
% fields = {'state'};
% for i_mod = 1:numel(fields)
%     for i_trial = 1:length(trial_range)
%         figure;
%         plot(grasp.(fields{i_mod}){trial_range(i_trial)}(:, 2:end));
%     end
% end