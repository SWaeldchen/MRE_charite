
den_levels = [.001 .002 .005 .008 .01 .012 .015 .018 .02 .025 .03 .035 .04 .045 .05 .055 .06 .06 .07 .08 .09 .1];
n_levels = numel(den_levels);
U_den = cell(n_levels);
for den_lev = 1:n_levels
    tic
    den_fac = den_levels(den_lev);
    disp(den_fac);
    parfor m = 1:3
        den_temp(:,:,:,:,m) = dtdenoise_3d_mad_ogs_undec(U(:,:,:,:,m), den_fac);
        toc
    end
    U_den{den_lev} = den_temp;
    save('U_den.mat', 'U_den');
    toc
end