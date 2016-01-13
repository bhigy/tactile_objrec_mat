function [Ypred, Ytest, confidence] = hde_moments
    nb_iter = 10;
    t_snapshot = grasp.t_end - param.grasp_duration / 2;

    disp ('grasp.skin');
    modality = grasp.skin;
    [Xnb, Xmean, Xstd] = hd_compute_moments(hd_extract_col(modality, 2:105));
    Xf1 = hdf_fourier(Xnb);
    Xf2 = hdf_fourier(Xmean);
    Xf3 = hdf_fourier(Xstd);
    X{1} = Xf1;
    X{2} = Xf2;
    X{3} = Xf3;
    X{4} = [Xf1 Xf2 Xf3];
    X{5} = [Xf2 Xf3];

    disp ('grasp.skin_comp');
    modality = grasp.skin_comp;
    [Xnb, Xmean, Xstd] = hd_compute_moments(modality, 2:105);
    Xf1 = hdf_fourier(Xnb);
    Xf2 = hdf_fourier(Xmean);
    Xf3 = hdf_fourier(Xstd);
    X{6} = Xf1;
    X{7} = Xf2;
    X{8} = Xf3;
    X{9} = [Xf1 Xf2 Xf3];
    X{10} = [Xf2 Xf3];

    [Ypred, Ytest, confidence] = hda_rls(X, Y, nb_iter, param.nb_items_test);
    
end