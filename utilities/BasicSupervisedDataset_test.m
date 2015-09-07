addpath(genpath('/home/bhigy/dev/tactile_objrec_mat'));
init;

X = [11 12 13; 21 22 23; 31 32 33; 41 42 43; 51 52 53];
Y = [1; 2; 1; 1; 2];
set = BasicSupervisedDataset(X, Y);

%% Testing removeCat 
set1 = set;
set1.removeCat(1);
fprintf('Test removeCat: ');
if isequal(set1.X, [21 22 23; 51 52 53]) && isequal(set1.Y, [2; 2])
    fprintf('ok\n');
else
    fprintf(2, 'ko\n');
end