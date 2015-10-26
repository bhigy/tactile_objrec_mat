%% Visualizing data 
% Dimension reduction - SVD
P = S.get2DProjection(S.METH_SVD);
P.draw(S.Y, objects);

P = test.get2DProjection(test.METH_SVD);
P.draw(test.Y, objects);
P.draw(Ypred, objects(unique(Ypred)));

% Dimension reduction - t_NSE
P = S.get2DProjection(S.METH_TSNE, 5);
P.draw(S.Y, objects);

P = test.get2DProjection(test.METH_TSNE, 5);
P.draw(test.Y, objects);
P.draw(Ypred, objects(unique(Ypred)));