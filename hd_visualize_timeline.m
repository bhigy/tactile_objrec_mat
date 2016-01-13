D = hd_extract_col(grasp.wrench, 2);
% D = Xmean;

%% Plotting data
% categories = unique(labels);
% colors = linspecer(length(categories));

figure;
hold on;
range = 1:length(D);
for i = range
%     cat_id = find(arrayfun(@(x) isequal(categories(x), labels{3}(i)), 1:length(categories)));
%     plot(data, 'Color', colors(cat_id, :));
    % Colored based on time from the beginning
%     plot(D{i}, 'Color', [1 / length(D) * i, 0, 0]);
    plot(D{i});
%     l = data;
%     L = [L, l(1:600)];
end
legend(labels(range));
hold off;
