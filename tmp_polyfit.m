X = 1:size(data);
Y = data';

%% Check the polynomial level required
figure;
hold on;
plot(X, data);
L = {'data'};
deg_range = 25:47;
error = zeros(length(deg_range), 1);
for i = 1:length(deg_range)
    P = polyfit(X, Y, deg_range(i));
    f = polyval(P, X);
    error(i) = sum((Y - f).^2);
    plot(X, f);
    L(end + 1) = {num2str(i)};
end
legend(L);
hold off

figure
plot(deg_range, error);
