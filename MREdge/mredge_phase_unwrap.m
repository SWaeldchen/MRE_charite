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
for s = 1:numel(info.ds.subdirs_comps_files)
    subdir = info.ds.subdirs_comps_files(s);
    vol_path = cell2str(fullfile(info.ds.list(info.ds.enum.phase), subdir));
    vol = load_untouch_nii_eb(vol_path);
    if strcmp(prefs.phase_unwrap, 'laplacian') || strcmp(prefs.phase_unwrap, 'laplacian2d')
        %pu6d = com.ericbarnhill.magnitude.Unwrapper6D;
        %vol.img = pu6d.unwrap(vol.img, 0);
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
        NIF_EXT = getenv('NIFTI_EXTENSION');
        phase_dir = cell2str(fullfile(info.ds.list(info.ds.enum.phase), subdir));
        avg_path = fullfile(MAG_SUB, ['Avg_Magnitude', NIF_EXT]);
        path_list = mredge_split_4d(phase_dir);
        if prefs.phase_unwrapping_settings.force_prelude_3d == 1
            prelude_force_term = 'f';
        else
            prelude_force_term = 's';
        end
        for n = 1:numel(path_list)
            path = path_list{n};
            path = mredge_zip_if_unzip(path);
            halve_values_and_save(path);
            path_temp = path(1:end-4);
            path_temp = [path_temp, '_temp', '.nii.gz']; %#ok<AGROW>
            copyfile(path, path_temp);
            prelude_command = ['fsl5.0-prelude -',prelude_force_term,'v -p ',path,' -a ',avg_path,' -o ',path_temp]; %#ok<NASGU>
            evalc('system(prelude_command);');
            copyfile(path_temp, path);
            delete(path_temp);
            mredge_unzip_if_zip(path);
        end
        mredge_3d_to_4d(path_list, phase_dir);
        recenter_volumes(phase_dir, info, prefs);
    end
end
 
    

end

function halve_values_and_save(path)

vol = load_untouch_nii_eb(path);
vol.img = vol.img ./ 2;
save_untouch_nii_eb(vol, path);

end

function recenter_volumes(phase_dir, info, prefs)
    mask = mredge_load_mask(info, prefs);
    vol = load_untouch_nii_eb(phase_dir);
    for n = 1:size(vol.img,4)
        vol3d = vol.img(:,:,:,n);
        mn = mean(vol3d(logical(mask)));
        mn_rd = round(mn/pi);
        vol3d = vol3d - pi*mn_rd;
        mn = mean(vol3d(logical(mask)));
        vol.img(:,:,:,n) = vol3d;
        %fprintf('%s %d %0.2f, \n', 'volumetric mean for volume ',n, mn);
    end
    save_untouch_nii_eb(vol, phase_dir);
end
