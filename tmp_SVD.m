[U, S, ~] = svd(Xf1);
proj = U*S;
X = proj(:, 1:9);

singular_val = zeros(size(S, 1), 1);
for i = 1:size(S, 1)
    singular_val(i) = S(i, i);
end
plot(singular_val);
