% D = hd_extract_col(weigh.wrench, 5);
D = Xmean;

%% Plotting data
% categories = unique(labels);
% colors = linspecer(length(categories));

figure;
hold on;
range = 1:359;
for i = range
%     cat_id = find(arrayfun(@(x) isequal(categories(x), labels{3}(i)), 1:length(categories)));
%     plot(data, 'Color', colors(cat_id, :));
%     plot(D{i}, 'Color', [1 / length(D) * i, 0, 0]);
    plot(D{i});
%     l = data;
%     L = [L, l(1:600)];
end
legend(labels(range));
hold off;

% wrench-2
%[1:5, 7:8, 10:23, 25:30, 32:158, 160:173, 175:269, 271:length(D)]
% wrench-3
%[1:5, 7:8, 10:158, 160:173, 175:269, 271:length(D)]
% wrench-4
%[1:5, 7:8, 10:158, 160:173, 175:269, 271:length(D)]