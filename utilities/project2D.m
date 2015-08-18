function P = project2D(X, method)
%project2D get a 2D projection of the data in X
%   method can be 'svd' or 'tsne'

    switch method
        case 'svd'
            [U, S, ~] = svd(X);
            P = U*S;
            P = P(:, 1:2);
        case 'tsne'
            P = fast_tsne(X);
    end

end

