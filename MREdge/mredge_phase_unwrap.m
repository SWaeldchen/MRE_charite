function mredge_phase_unwrap(info, prefs)
%
% Part of the MREdge software package
% Created 2016 by Eric Barnhill for Charite Medical University Berlin
% Private usage only. Distribution only by permission of Elastography working
% group.
%
%
% USAGE:
%
%   calls phase unwrapping methods on the data. laplacian and rga
%   methods require the Java .jar . PRELUDE method requires 
%   FSL. PUMA requires installation of PUMA.
%
% INPUTS:
%
%   info - MREdge acquisition info structure generated with mredge_acquisition_info
%   prefs - MREdge preferences structure generated with mredge_prefs
%
% OUTPUTS:
%
%   none

%if strcmpi(prefs.phase_unwrap, 'prelude')
%    mredge_normalize_phase_prelude(info,prefs);
%else
    mredge_normalize_phase(info, prefs);
%end
parfor s = 1:numel(info.ds.subdirs_comps)
    subdir = info.ds.subdirs_comps(s);
    vol_path = cell2str(fullfile(info.ds.list(info.ds.enum.phase), subdir));
    vol = load_untouch_nii_eb(vol_path);
    if strcmp(prefs.phase_unwrap, 'laplacian') || strcmp(prefs.phase_unwrap, 'laplacian2d')
        vol.img = dct_unwrap(vol.img, 2);
        save_untouch_nii(vol, vol_path);
    elseif strcmp(prefs.phase_unwrap, 'rga') == 1
        rg4d = com.ericbarnhill.phaseTools.RG4D;
        rg4d.setDifferencesFilePath(RGA_DIFFERENCES_FILE_PATH);
        mask = mredge_load_mask(info,prefs);
        vol_unmasked = normalizeImage(double(vol.img));
        vol_masked = zeros(size(vol.img));
        for n = 1:size(vol.img, 4)
            vol_masked(:,:,:,n) = double(vol.img(:,:,:,n)) .* double(mask);
        end
        vol_masked(vol_masked == 0) = nan;
        vol_masked =  rga_progressive(vol_masked, rg4d); 
        vol_masked(isnan(vol_masked)) = vol_unmasked(isnan(vol_masked));
        vol.img = vol_masked;
        save_untouch_nii(vol, vol_path);
    elseif strcmp(prefs.phase_unwrap, 'prelude') == 1
        MAG_SUB = mredge_analysis_path(info, prefs, 'Magnitude');
        avg_path = fullfile(MAG_SUB, ['Avg_Magnitude', NIF_EXT]);
        path_list = mredge_split_4d(phase_SUB, f, c, info);
        if prefs.phase_unwrapping_settings.force_prelude_3d == 1
            prelude_force_term = 'f';
        else
            prelude_force_term = 's';
        end
        for n = 1:numel(path_list)
            path = path_list{n};
            path_temp = path(1:end-7);
            path_temp = [path_temp, '_temp', 'nii.gz']; %#ok<AGROW>
            copyfile(path, path_temp);
            prelude_command = ['fsl5.0-prelude -',prelude_force_term,'v -p ',path,' -a ',avg_path,' -o ',path_temp];
            system(prelude_command);
            copyfile(path_temp, path);
            delete(path_temp);
        end
        mredge_3d_to_4d(path_list, phase_SUB, f, c);
    end
end
 
    

end
