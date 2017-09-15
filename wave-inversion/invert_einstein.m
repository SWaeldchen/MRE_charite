function absg = invert(info)

    % load images
    mag = cat_niftis(info.magnitude_paths);
    phase_raw = cat_niftis(info.phase_paths);

    % make subtraction phase images
    phase = phase_raw(:,:,:,:,:,1:2:end) - phase_raw(:,:,:,:,:,1:2:end);

    % make magnitude mask
    mask = double(mean(resh(mag, 4), 4) > info.mask_thresh);

    % denoise the data
    phase_den = sfwi_preprocess(phase, 0, 1, 2, info.den_fac, nan, mask, info.butter_cut);

    % invert the data
    if strcmpi(info.method, 'mdev')
        absg = helmholtz_inversion(phase_den, info.freqs, info.spacing, 3, 4, 1);
    elseif strcmpi(info.method, 'sfwi')
        absg = sfwi_inversion(phase_den, info.freqs, info.spacing, [1 2 3], 1, 2);
    else
        disp('Unknown inversion method')
    end
    
end

function v = cat_niftis(paths)
    v = [];
    for n = 1:numel(paths)
        nifti_vol = load_untouch_nii(paths{n});
        v = cat(6, v, nifti_vol.img);
    end
end
    

