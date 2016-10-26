%% function mredge_load_mask(info,prefs);
%
% Part of the MREdge software package
% Created 2016 by Eric Barnhill for Charite Medical University Berlin
% Private usage only. Distribution only by permission of Elastography working
% group.
%
%
% USAGE:
%
% Loads the anatomical mask image and returns as a 3D object
%
% INPUTS:
%
% info - an acquisition info structure created with make_acquisition_info
% prefs - preferences file created with mredge_prefs
%
% OUTPUTS:
%
% none
%	
function mask = mredge_load_mask(info, prefs)

    [AVG_SUB] = set_dirs(info,prefs);
    mask_vol = load_untouch_nii(fullfile(AVG_SUB, 'Magnitude_Mask.nii.gz'));
	mask = mask_vol.img;

end

function [AVG_SUB] = set_dirs(info,prefs)

    MAG_SUB = fullfile(info.path, 'Magnitude');
	AVG_SUB = mredge_analysis_path(info, prefs, 'Magnitude');
            
end
