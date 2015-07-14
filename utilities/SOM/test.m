n = 10;
dim = 3;
X = rand(n, dim);

map = Map(10, 10, dim);
for nbIter = [250 250 500 1000]
    map.train(X, nbIter, 0.1);
    figure;
    image(map.get3D());
end

M = zeros(length(X),1,dim);
for i = 1:length(X)
    M(i,1,:) = X(i,:);
end
figure
image(M);