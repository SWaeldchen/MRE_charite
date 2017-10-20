function mredge_save_5d_as_FT (data_5d, info, prefs)

	FT_DIRS = set_dirs(info, prefs);
    num_freqs = numel(info.driving_frequencies);
    NIF_EXT = getenv('NIFTI_EXTENSION');
    for d = 1:numel(FT_DIRS)
        for f_num = 1:num_freqs
            f = info.driving_frequencies(f_num);
            for c = 1:3
                path = fullfile(FT_DIRS{d}, num2str(f), num2str(c), mredge_filename(f, c, NIF_EXT));
                vol = load_untouch_nii_eb(path);
                vol.img = data_5d(:,:,:,c,f_num);
                save_untouch_nii(vol, path);
            end
        end
    end
        
end
 
function FT_DIRS = set_dirs(info, prefs)
    FT_DIRS = mredge_get_ft_dirs(info, prefs);
end

