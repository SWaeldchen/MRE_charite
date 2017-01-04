%% function mredge_cortical_average(info, prefs);
%
% Part of the MREdge software package
% Created 2016 by Eric Barnhill for Charite Medical University Berlin
% Private usage only. Distribution only by permission of Elastography working
% group.
%
%
% USAGE:
%
%   Using the previously set T2 mask, calculates cortical values for a
%   parameter
%
% INPUTS:
%
%   info - MREdge acquisition info structure generated with mredge_acquisition_info
%   prefs - MREdge preferences structure generated with mredge_prefs
%
% OUTPUTS:
%
%   none

function mredge_cortical_average(info, prefs)

    if prefs.outputs.absg == 1
        cortex(info, prefs, 'Abs_G');
    end
    if prefs.outputs.phi == 1
        cortex(info, prefs, 'Phi');
    end
    if prefs.outputs.c == 1
        cortex(info, prefs, 'C');
    end
    if prefs.outputs.a == 1
        cortex(info, prefs, 'A');
    end
    if prefs.outputs.amplitude == 1
        cortex(info, prefs, 'Amp');
    end
end

function cortex(info, prefs, param)

	display(['Cortical Averages ',param]);

    [PARAM_SUB, STATS_SUB] = set_dirs(info, prefs, param);
    NIFTI_EXTENSION = '.nii.gz';
    param_path = fullfile(PARAM_SUB, 'MDEV.nii.gz');
    param_vol = load_untouch_nii_eb(param_path);
    param_img = param_vol.img;
	mask = double(mredge_load_mask(info,prefs));
	cortex_masked = double(mask).*double(mredge_cortex_3d(param_img));
	cortex_masked(cortex_masked == 0) = nan;
    param_cortex = median(cortex_masked(~isnan(cortex_masked)));
    fileID = fopen(fullfile(STATS_SUB, [ 'cortex_',param,'.csv']), 'w');
    fprintf(fileID, 'F, Cortical Average \n');
    fprintf(fileID, 'MDEV, %1.4f \n', param_cortex);
	save(fullfile(PARAM_SUB, 'MDEV_cortex_image.mat'), 'cortex_masked');
    for f = info.driving_frequencies
		display([num2str(f), 'Hz']);
        param_path = fullfile(PARAM_SUB, num2str(f), [num2str(f), NIFTI_EXTENSION]);
        param_vol = load_untouch_nii_eb(param_path);
        param_img = param_vol.img;
        cortex_masked = double(mask).*double(mredge_cortex_3d(param_img));
		cortex_masked(cortex_masked == 0) = nan;
    	param_cortex = median(cortex_masked(~isnan(cortex_masked)));
		save(fullfile(PARAM_SUB, [ num2str(f), '_cortex_image.mat']), 'cortex_masked');
        fileID = fopen(fullfile(STATS_SUB, [ 'cortex_',param,'.csv']), 'a');
        fprintf(fileID, '%d, %1.4f \n', f, param_cortex);
    end
    fclose('all');

end 
    
function [PARAM_SUB, STATS_SUB] = set_dirs(info, prefs, param)

    PARAM_SUB = mredge_analysis_path(info, prefs, param);
    STATS_SUB = mredge_analysis_path(info, prefs, 'Stats');
    
end

