% Test set for findClosest function
A = [5 6 7 10];
B = [1 1 2];
C = [1 7 15];
D = [2 9];
E = [7 8 10];
F = [1 15];
G = [1 5 10 20];
H = [8 9 13];
I = [7];

%% Test 1
[values, indexes] = find_closest(A, B);
fprintf('Test 1: ');
if(isequal(values, [2;2;2;2]) && isequal(indexes, [3;3;3;3]))
    fprintf('ok\n');
else
    fprintf(2, 'ko\n');
end

%% Test 2
[values, indexes] = find_closest(B, A);
fprintf('Test 2: ');
if(isequal(values, [5;5;5]) && isequal(indexes, [1;1;1]))
    fprintf('ok\n');
else
    fprintf(2, 'ko\n');
end

%% Test 3
[values, indexes] = find_closest(C, D);
fprintf('Test 3: ');
if(isequal(values, [2;9;9]) && isequal(indexes, [1;2;2]))
    fprintf('ok\n');
else
    fprintf(2, 'ko\n');
end

%% Test 4
[values, indexes] = find_closest(E, F);
fprintf('Test 4: ');
if(isequal(values, [1;1;15]) && isequal(indexes, [1;1;2]))
    fprintf('ok\n');
else
    fprintf(2, 'ko\n');
end

%% Test 5
[values, indexes] = find_closest(G, H);
fprintf('Test 5: ');
if(isequal(values, [8;8;9;13]) && isequal(indexes, [1;1;2;3]))
    fprintf('ok\n');
else
    fprintf(2, 'ko\n');
end

%% Test 6
[values, indexes] = find_closest(G, I);
fprintf('Test 6: ');
if(isequal(values, [7;7;7;7]) && isequal(indexes, [1;1;1;1]))
    fprintf('ok\n');
else
    fprintf(2, 'ko\n');
end