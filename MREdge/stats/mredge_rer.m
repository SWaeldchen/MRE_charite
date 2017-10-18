%% function mredge_rer(info, prefs);
%
% Part of the MREdge software package
% Created 2016 by Eric Barnhill for Charite Medical University Berlin
% Private usage only. Distribution only by permission of Elastography working
% group.
%
%
% USAGE:
%
%   Calculates reduced energy ratio (RER) for a parameter,
%   using the 2D method in the paper found in
%   Lee, S. Y., Yoo, J. T., Kumar, Y., & Kim, S. W. (2009). 
%   Reduced energy-ratio measure for robust autofocusing in digital camera. 
%   IEEE Signal Processing Letters, 16(2), 133-136.
%
% INPUTS:
%
%   info - MREdge acquisition info structure generated with mredge_acquisition_info
%   prefs - MREdge preferences structure generated with mredge_prefs
%
% OUTPUTS:
%
%   none

function mredge_rer(info, prefs)

    if prefs.outputs.absg == 1
        rer(info, prefs, 'Abs_G');
    end
    if prefs.outputs.phi == 1
        rer(info, prefs, 'Phi');
    end
    if prefs.outputs.c == 1
        rer(info, prefs, 'C');
    end
    if prefs.outputs.a == 1
        rer(info, prefs, 'A');
    end
    if prefs.outputs.amplitude == 1
        rer(info, prefs, 'Amp');
    end
end

function rer(info, prefs, param)

	display(['RER ',param]);

    [PARAM_SUB, STATS_SUB] = set_dirs(info, prefs, param);
    NIF_EXT = '.nii.gz';
    param_path = fullfile(PARAM_SUB, 'MDEV.nii.gz');
    param_vol = load_untouch_nii_eb(param_path);
    param_img = param_vol.img;
	mask = mredge_load_mask(info,prefs);
	rer_masked = double(mask).*double(mredge_rer_3d(param_img));
	rer_masked(rer_masked == 0) = nan;
    param_rer = median(rer_masked(~isnan(rer_masked)));
    fileID = fopen(fullfile(STATS_SUB, [ 'rer_',param,'.csv']), 'w');
    fprintf(fileID, 'MDEV, %1.4f \n', param_rer);
	save(fullfile(PARAM_SUB, 'MDEV_rer_image.mat'), 'rer_masked');
    for f = info.driving_frequencies
		display([num2str(f), 'Hz']);
        param_path = fullfile(PARAM_SUB, num2str(f), [num2str(f), NIF_EXT]);
        param_vol = load_untouch_nii_eb(param_path);
        param_img = param_vol.img;
        rer_masked = double(mask).*double(mredge_rer_3d(param_img));
		rer_masked(rer_masked == 0) = nan;
    	param_rer = median(rer_masked(~isnan(rer_masked)));
		save(fullfile(PARAM_SUB, [ num2str(f), '_rer_image.mat']), 'rer_masked');
        fileID = fopen(fullfile(STATS_SUB, [ 'rer_',param,'.csv']), 'a');
        fprintf(fileID, '%d, %1.4f \n', f, param_rer);
    end
    fclose('all');

end 
    
function [PARAM_SUB, STATS_SUB] = set_dirs(info, prefs, param)

    PARAM_SUB = mredge_analysis_path(info, prefs, param);
    STATS_SUB = mredge_analysis_path(info, prefs, 'stats');
    
end

