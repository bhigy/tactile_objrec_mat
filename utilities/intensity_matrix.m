function intensity_matrix(M)
    imagesc(M);
    axis image;
    colormap(gray(256));
    caxis([0,1]);
    colorbar;
end