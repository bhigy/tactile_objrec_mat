function valid = hd_compute_moments_test

    D = cell(2, 1);
    exp_nb = cell(2, 1);
    exp_mean = cell(2, 1);
    exp_std = cell(2, 1);
    D{1} = [1 2 2
            1 2 4
            1 2 6];
    D{2} = [0 0 1 0
            0 0 1 1
            0 0 1 2];
    exp_nb{1} = [3 3 3];
    exp_nb{2} = [0 0 3 2];
    exp_mean{1} = [1 2 4];
    exp_mean{2} = [0 0 1 1];
    exp_std{1} = [0 0 2];
    exp_std{2} = [0 0 0 1];
    
    [res_nb, res_mean, res_std] = hd_compute_moments(D);
    v_nb = sum(sum(res_nb{1} == exp_nb{1})) + sum(sum(res_nb{2} == exp_nb{2}));
    v_nb = (v_nb == (length(exp_nb{1}) + length(exp_nb{2})));
    v_mean = sum(sum(res_mean{1} == exp_mean{1})) + sum(sum(res_mean{2} == exp_mean{2}));
    v_mean = (v_mean == (length(exp_mean{1}) + length(exp_mean{2})));
    v_std = sum(sum(res_std{1} == exp_std{1})) + sum(sum(res_std{2} == exp_std{2}));
    v_std = (v_std == (length(exp_std{1}) + length(exp_std{2})));
    valid = v_nb && v_mean && v_std;
end