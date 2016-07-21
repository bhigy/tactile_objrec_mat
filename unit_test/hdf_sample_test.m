function valid = hdf_sample_test

    D = cell(2, 1);
    D{1} = [1 2 3 4 5 6 7 8
            9 8 7 6 5 4 3 2];
    D{2} = [11 12 13 14 15 16 17 18
            19 18 17 16 15 14 13 12];
    exp_res = [ 1  5  8  9  5  2
               11 15 18 19 15 12];
              
    res = hdf_sample(D, 3);
    valid = sum(sum(res == exp_res)) == (size(exp_res, 1) * size(exp_res, 2));

end