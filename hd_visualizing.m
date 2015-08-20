%% Visualizing data 
% Dimension reduction - SVD
P = S.get2DProjection(S.METH_SVD);
P.draw(S.Y, objects);
P.draw(Ypred, objects(unique(Ypred)));

% Dimension reduction - t_NSE
P = S.get2DProjection(S.METH_TSNE, 5);
P.draw(S.Y, objects);
P.draw(Ypred, objects(unique(Ypred)));