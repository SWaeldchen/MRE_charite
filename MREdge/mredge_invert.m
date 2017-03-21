%% function mredge_invert(info, prefs);
%
% Part of the MREdge software package
% Created 2016 by Eric Barnhill for Charite Medical University Berlin
% Private usage only. Distribution only by permission of Elastography working
% group.
%
%
% USAGE:
%
%   to come
%
% INPUTS:
%
%   info - MREdge acquisition info structure generated with mredge_acquisition_info
%   prefs - MREdge preferences structure generated with mredge_prefs
%
% OUTPUTS:
%
%   none

function mredge_invert(info, prefs)

if strcmpi(prefs.inversion_strategy, 'MDEV')
    if prefs.outputs.absg == 1
        mredge_invert_param_mdev(info, prefs, 'Abs_G');
    end
    if prefs.outputs.phi == 1
        mredge_invert_param_mdev(info, prefs, 'Phi');
    end
    if prefs.outputs.c == 1
        mredge_invert_param_mdev(info, prefs, 'c');
    end
    if prefs.outputs.a == 1
        mredge_invert_param_mdev(info, prefs, 'a');
    end
elseif strcmpi(prefs.inversion_strategy, 'SFWI')
	mredge_invert_sfwi(info, prefs);
end



