function data_5d = mredge_load_data_as_5d (info, prefs)

	FT_DIRS = set_dirs(info, prefs);
    num_freqs = numel(info.driving_frequencies);
    NIFTI_EXTENSION = getenv('NIFTI_EXTENSION');
    data_5d = [];
    for d = 1:numel(FT_DIRS)
        for f_num = 1:num_freqs
            f = info.driving_frequencies(f_num);
            components = [];
            for c = 1:3
                path = fullfile(FT_DIRS{d}, num2str(f), num2str(c), mredge_filename(f, c, NIFTI_EXTENSION));
                vol = load_untouch_nii_eb(path);
                img = vol.img;
                components = cat(4, components, img);
            end
            data_5d = cat(5, data_5d, components);
        end
    end
        
end
 
function FT_DIRS = set_dirs(info, prefs)
    FT_DIRS = mredge_get_ft_dirs(info, prefs);
end

