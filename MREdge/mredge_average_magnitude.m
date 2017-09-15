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
    [AVG_SUB, MAG_SUB] = set_dirs(info, prefs);
    NIF_EXT = getenv('NIFTI_EXTENSION');
    if ~exist(AVG_SUB, 'dir')
        mkdir(AVG_SUB);
    end
    
    avg_vol = [];

    for f = info.driving_frequencies
        for c = 1:3
            mag_path = fullfile(MAG_SUB, num2str(f), num2str(c), mredge_filename(f, c, NIF_EXT));
            mag_vol = load_untouch_nii_eb(mag_path);
            if isempty(avg_vol) % use first volume of first image as placeholder
                avg_vol = load_untouch_nii_eb(mag_path);
                avg_vol.img = avg_vol.img(:,:,:,1);
                avg_vol.img = zeros(size(avg_vol.img));
                avg_vol.hdr.dime.dim(1) = 3;
                avg_vol.hdr.dime.dim(5) = 1;
            else
                avg_vol.img = avg_vol.img + sum(mag_vol.img,4);
            end
        end
    end
    
    avg_vol.img = avg_vol.img ./ ( numel(info.driving_frequencies) * 3 * info.time_steps);
    avg_path = fullfile(AVG_SUB, 'Avg_Magnitude', NIF_EXT);
    save_untouch_nii_eb(avg_vol, avg_path);
    avg_vol.img(avg_vol.img <= prefs.anat_mask_thresh) = 0;
    avg_vol.img(avg_vol.img > prefs.anat_mask_thresh) = 1;
    avg_vol.img = double(avg_vol.img);
	mask_path = fullfile(AVG_SUB, 'Magnitude_Mask', NIF_EXT);
	save_untouch_nii_eb(avg_vol, mask_path);
end

function [AVG_SUB, MAG_SUB] = set_dirs(info, prefs)

    MAG_SUB = fullfile(info.path, 'magnitude');
    AVG_SUB = mredge_analysis_path(info,prefs, 'Magnitude');
            
end
