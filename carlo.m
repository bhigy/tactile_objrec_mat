mods = {'analograw', 'analogfourier', 'springyraw', 'springyfourier', 'stateraw', 'statefourier', 'wrenchraw', 'wrenchfourier', 'cartwrenchraw', 'cartwrenchfourier'};
i = 1;
for condition = [1:2, 4:5, 7:8, 10:11, 13:14]
    for j = 1:11
        subset = X{condition}(Y == j, :);
        fname = [mods{i}, '_', objects{j}, '.mat'];
        save([param.root, 'matlab/carlo/', fname], 'subset');
    end
    i = i + 1;
end