range = 50:10:1000;
nb_iter = 10;

Ypred      = cell(length(range), 1);
Ytest      = cell(length(range), 1);
confidence = cell(length(range), 1);

i = 1;
for nb_samples = range
    X{1} = hdf_sample(hd_extract_col(grasp.analog, 2:7), nb_samples);
    X{2} = hdf_sample(hd_extract_col(grasp.wrench, 2:7), nb_samples);
    X{3} = hdf_sample(hd_extract_col(weigh.analog, 2:7), nb_samples);
    X{4} = hdf_sample(hd_extract_col(weigh.wrench, 2:7), nb_samples);
    X{5} = hdf_sample(hd_extract_col(rotate.analog, 2:7), nb_samples);
    X{6} = hdf_sample(hd_extract_col(rotate.wrench, 2:7), nb_samples);
    [Ypred{i}, Ytest{i}, confidence{i}] = hda_rls(X, Y, nb_iter, param.nb_items_test);

    i = i + 1;
end