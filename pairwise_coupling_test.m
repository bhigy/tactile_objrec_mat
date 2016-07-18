function res = pairwise_coupling_test

r = [0 0.9 0.4; 0.1 0 0.7; 0.6 0.3 0];
P = pairwise_coupling(r, [], 0.01);
res = all(round(P, 4) == [0.4786; 0.2427; 0.2787]);

end