%% function mredge_convert_norm_thresh_to_wpm(thresh, voxel_spacing, h, w);
%
% Part of the MREdge software package
% Created 2016 by Eric Barnhill for Charite Medical University Berlin
% Private usage only. Distribution only by permission of Elastography working
% group.
%
%
% USAGE:
%
%   Converts a normalized threshold to waves per meter. Assumes isotropic
%	in-plane voxels. Applies norm thresh to smallest dimension h or w.
%
% INPUTS:
%
%   thresh - normalized threshold
%	voxel_spacing - in meters
%
% OUTPUTS:
%
%   none

function wpm = mredge_convert_norm_thresh_to_wpm(thresh, voxel_spacing, h, w)

	shortest_dim = min(h,w);
	norm_dist = thresh*shortest_dim;
	norm_dist_m = norm_dist*voxel_spacing;
	wpm = 1 / norm_dist_m;

end
