%% function mredge_phase_unwrap(info, prefs);
%
% Part of the MREdge software package
% Created 2016 by Eric Barnhill for Charite Medical University Berlin
% Private usage only. Distribution only by permission of Elastography working
% group.
%
%
% USAGE:
%
%   calls gaussian smoothing on real and imaginary MRE acquisition data
%	(prior to phase unwrapping)
%
% INPUTS:
%
%   info - MREdge acquisition info structure generated with mredge_acquisition_info
%   prefs - MREdge preferences structure generated with mredge_prefs
%
% OUTPUTS:
%
%   none

function mredge_phase_unwrap(info, prefs)

PHASE_SUB = fullfile(info.path, 'Phase');
%MAG_SUB = fullfile(info.path, 'Mag');
NIFTI_EXTENSION = getenv('NIFTI_EXTENSION');
RGA_DIFFERENCES_FILE_PATH = '/home/ericbarnhill/barnhill-eclipse-workspace/PhaseTools/differences.dat';

if strcmp(prefs.phase_unwrap,'gradient') == 1
    PHASE_X_SUB = fullfile(info.path, 'Phase_X');
    PHASE_Y_SUB = fullfile(info.path, 'Phase_Y');
end
mredge_normalize_phase(info, prefs);
for f = info.driving_frequencies
    for c = 1:3
        vol_dir = fullfile(PHASE_SUB, num2str(f), num2str(c));
        vol_path = fullfile(vol_dir, mredge_filename(f, c, NIFTI_EXTENSION));
        vol = load_untouch_nii_eb(vol_path);
        if strcmp(prefs.phase_unwrap, 'laplacian') || strcmp(prefs.phase_unwrap, 'laplacian2d')
            vol.img = dct_unwrap(vol.img, 2);
            save_untouch_nii(vol, vol_path);
        elseif strcmp(prefs.phase_unwrap, 'gradient') == 1
            [x_gradient, y_gradient] = mredge_gradient_unwrap(vol.img,prefs);
            vol_x = vol;
            vol_y = vol;
            vol_x.img = x_gradient;
            vol_y.img = y_gradient;
            if ~exist(PHASE_X_SUB, 'dir')
                mkdir(PHASE_X_SUB);
            end
            if ~exist(PHASE_Y_SUB, 'dir')
                mkdir(PHASE_Y_SUB);
            end
            
            mkdir(fullfile(PHASE_X_SUB, int2str(f), int2str(c)));
            mkdir(fullfile(PHASE_Y_SUB, int2str(f), int2str(c)));
            
            x_path = fullfile(PHASE_X_SUB, int2str(f), int2str(c), mredge_filename(f, c, '.nii.gz'));
            y_path = fullfile(PHASE_Y_SUB, int2str(f), int2str(c), mredge_filename(f, c, '.nii.gz'));
                        
            save_untouch_nii(vol_x, x_path);
            save_untouch_nii(vol_y, y_path);
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
            avg_path = fullfile(MAG_SUB, ['Avg_Magnitude', NIFTI_EXTENSION]);
            %mask_path = fullfile(MAG_SUB, 'Magnitude_Mask.nii.gz');
            path_list = mredge_split_4d(PHASE_SUB, f, c, info);
            prelude_force_term = '';
            if prefs.phase_unwrapping_settings.force_prelude_3d == 1
                prelude_force_term = 'f';
            end
            for n = 1:numel(path_list)
                path = path_list{n};
                path_temp = path(1:end-7);
                path_temp = [path_temp, '_temp', NIFTI_EXTENSION]; %#ok<AGROW>
                copyfile(path, path_temp);
                prelude_command = ['fsl5.0-prelude -',prelude_force_term,'v -p ',path,' -a ',avg_path,' -o ',path_temp];
                system(prelude_command);
                copyfile(path_temp, path);
                delete(path_temp);
            end
            mredge_3d_to_4d(path_list, PHASE_SUB, f, c);
        end
    end
 
    

end
