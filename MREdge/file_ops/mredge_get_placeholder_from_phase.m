function nifti_placeholder = mredge_get_placeholder_from_phase (info)

    PHASE_SUB = set_dirs(info);
    for f = info.driving_frequencies(1)
      for c = 1
        % split to get a 3D file
        file_list_mag = mredge_split_4d(PHASE_SUB, f, c, info);
        nifti_placeholder = load_untouch_nii_eb(file_list_mag{1});
        nifti_placeholder.img = double(nifti_placeholder.img);
        nifti_placeholder.hdr.dime.datatype = 64;
      end
    end
    

end

function PHASE_SUB = set_dirs(info)
    PHASE_SUB = fullfile(info.path, 'Phase');
end