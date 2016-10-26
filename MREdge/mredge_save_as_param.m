function mredge_save_as_param (info, prefs, param_name, data, nifti_placeholder)

    ANALYSIS_SUB = mredge_analysis_path(info, prefs);
    nifti_placeholder.img = data;
    save_untouch_nii(nifti_placeholder, fullfile(ANALYSIS_SUB, [param_name, '.nii']));
    
end
