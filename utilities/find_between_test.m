addpath(genpath('/home/bhigy/dev/tactile_objrec_mat'));
init;

M = [2 5 14 17 23]

%% Test 1
lines = find_between(14, 5, M);
fprintf('Test 1: ');
if isequal(lines, [])
    fprintf('ok\n');
else
    fprintf(2, 'ko\n');
end

%% Test 2
lines = find_between(0, 1, []);
fprintf('Test 2: ');
if isequal(lines, [])
    fprintf('ok\n');
else
    fprintf(2, 'ko\n');
end


%% Test 3
lines = find_between(0, 1, M);
fprintf('Test 3: ');
if isequal(lines, [])
    fprintf('ok\n');
else
    fprintf(2, 'ko\n');
end

%% Test 4
lines = find_between(25, 26, M);
fprintf('Test 4: ');
if isequal(lines, [])
    fprintf('ok\n');
else
    fprintf(2, 'ko\n');
end

%% Test 5
lines = find_between(1, 25, M);
fprintf('Test 5: ');
if isequal(lines, 1:5)
    fprintf('ok\n');
else
    fprintf(2, 'ko\n');
end

%% Test 6
lines = find_between(5, 17, M);
fprintf('Test 6: ');
if isequal(lines, 2:4)
    fprintf('ok\n');
else
    fprintf(2, 'ko\n');
end

%% Test 7
lines = find_between(13, 15, M);
fprintf('Test 7: ');
if isequal(lines, [])
    fprintf('ok\n');
else
    fprintf(2, 'ko\n');
end