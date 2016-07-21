function valid = hdf_snapshot_test

    D{1} = [1 2 3 4
            2 6 7 8
            3 7 6 5
            4 6 4 3];
    D{2} = [1 2 3 4
            2 6 7 8
            3 7 6 5
            4 6 4 9];
    exp_res = [3 4
               4 9];
    res = hdf_snapshot(D, [1 4], 3:4);
    valid = sum(sum(res == exp_res)) == (size(exp_res, 1) * size(exp_res, 2));

end