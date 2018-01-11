function mredge_3d_to_4d(path_3d_array, path_4d)
% Convert cell array of 3D nii files to single 4D nii file. 
%
% INPUTS:
%
% path_array: array of paths of 3d objects
% path_4d: path for saving 4d object
%
% OUTPUTS:
%
% none
%
% Part of the MREdge software package
% Created 2016 at Charite Medical University Berlin
% So that we can vouch for results, 
% this code is source-available but not open source.
% Please contact Eric Barnhill at ericbarnhill@protonmail.ch 
% for permission to make modifications.
%
vol_4d = [];

for n = 1:numel(path_3d_array)
  vol = load_untouch_nii(path_3d_array{n});
  if n == 1
      vol_4d = vol;
  else
      vol_4d.img = cat(4, vol_4d.img, vol.img);
  end
end

im_sz = size(vol_4d.img);
vol_4d.hdr.dime.dim(5) = im_sz(4);
vol_4d.hdr.dime.dim(1) = 4;
save_untouch_nii(vol_4d, path_4d);
      
