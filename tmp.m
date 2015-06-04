root_path = '/home/bhigy/datadumps';
X_path = fullfile(root_path, 'venerdi26');
y_path = fullfile(root_path, 'venerdi26');

[Xte, Yte] = load_and_save_xy ('/home/bhigy/datadumps/venerdi26', [], [], y_path, X_path, []);

