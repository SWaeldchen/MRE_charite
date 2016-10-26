%% function mredge_average_magnitude(info, prefs);
%
% Part of the MREdge software package
% Created 2016 by Eric Barnhill for Charite Medical University Berlin
% Private usage only. Distribution only by permission of Elastography working
% group.
%
%
% USAGE:
%
% This function will create a single, averaged t2 magnitude map from
% an MRE acquisition. This greatly increases SNR of the acquisition
% and is the preferred volume for co-registration and segmentation.
%
% INPUTS:
%
% info - an acquisition info structure created with make_acquisition_info
%
% OUTPUTS:
%
% none
%	
function mredge_average_magnitude(info, prefs)
    tic
    [AVG_SUB, MAG_SUB] = set_dirs(info, prefs);
    
    if ~exist(AVG_SUB, 'dir')
        mkdir(AVG_SUB);
    end
    
    avg_vol = [];

    for f = info.driving_frequencies
        for c = 1:3
            mag_path = fullfile(MAG_SUB, num2str(f), num2str(c), mredge_filename(f, c, '.nii.gz'));
            mag_vol = load_untouch_nii(mag_path);
            if isempty(avg_vol) % use first volume of first image as placeholder
                first_path = fullfile(MAG_SUB, num2str(f), num2str(c), 'first.nii.gz');
                fslroi_command = ['fsl5.0-fslroi ', mag_path, ' ', first_path, ' ', ' 0 1'];
                system(fslroi_command);
                avg_vol = load_untouch_nii(first_path);
                avg_vol.img = zeros(size(avg_vol.img));
                delete(first_path);
            else
                avg_vol.img = avg_vol.img + sum(mag_vol.img,4);
            end
        end
    end
    
    avg_vol.img = avg_vol.img ./ ( numel(info.driving_frequencies) * 3 * info.time_steps);
    avg_path = fullfile(AVG_SUB, 'Avg_Magnitude.nii.gz');
    save_untouch_nii(avg_vol, avg_path);
    avg_vol.img(avg_vol.img <= prefs.anat_mask_thresh) = 0;
    avg_vol.img(avg_vol.img > prefs.anat_mask_thresh) = 1;
    avg_vol.img = double(avg_vol.img);
	mask_path = fullfile(AVG_SUB, 'Magnitude_Mask.nii.gz');
	save_untouch_nii(avg_vol, mask_path);
    toc
end

function [AVG_SUB, MAG_SUB] = set_dirs(info, prefs)

    MAG_SUB = fullfile(info.path, 'Magnitude');
    AVG_SUB = mredge_analysis_path(info,prefs, 'Magnitude');
            
end
