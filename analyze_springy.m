% Analysing springy values
% Ball vs soft_all
figure;
plot(springy(1:1231,3));
hold on;
plot(springy(1:1231,5));
plot(springy(12999:14334,3));
plot(springy(12999:14334,5));
legend('ball - thumb', 'ball - middle', 'soft ball - thumb', 'soft ball - middle');
hold off;