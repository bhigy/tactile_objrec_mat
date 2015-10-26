function Ypred = predicted_cat(model, X, Y)

    C = zeros(size(X, 1));
    for i = 1:size(X, 1)
        [~, C(i)] = min(vl_alldist(X(i,:)', model));
    end
    Yc = arrayfun(@(x) mode(Y(C == x)),1:size(model,2));
    Ypred = zeros(size(X, 1), 1);
    for i = 1:size(X, 1)
        Ypred(i) = Yc(C(i));
    end
end