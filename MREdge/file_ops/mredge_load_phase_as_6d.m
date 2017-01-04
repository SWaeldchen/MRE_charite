function data_6d = mredge_load_phase_as_6d (info, prefs)

	PHASE_SUB = set_dirs(info);
    num_freqs = numel(info.driving_frequencies);
    NIFTI_EXTENSION = getenv('NIFTI_EXTENSION');
    data_6d = [];
    for f_num = 1:numel(info.driving_frequencies)
        f = info.driving_frequencies(f_num);
        components = [];
        for c = 1:3
            path = fullfile(PHASE_SUB, num2str(f), num2str(c), mredge_filename(f, c, NIFTI_EXTENSION));
            vol = load_untouch_nii_eb(path);
            img = vol.img;
            components = cat(5, components, img);
        end
        data_6d = cat(6, data_6d, components);
    end
    
end
 
function PHASE_SUB = set_dirs(info)
    PHASE_SUB = fullfile(info.path, 'Phase');
end

