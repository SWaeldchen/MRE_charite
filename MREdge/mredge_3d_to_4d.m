%% function mredge_spm_3d4d(path_arrary, path_4d)
%
% Part of the MREdge software package
% Created 2016 at Charite Medical University Berlin
% Private usage only. Distribution only by permission of Elastography working
% group.
%
% USAGE:
%
% Convert 3D to 4D nii file. 
%
% INPUTS:
%
% path_array: array of paths of 3d objects
% path_4d: path for saving 4d object
%
% OUTPUTS:
%
% none

function mredge_3d_to_4d(path_array, path_4d)
  
  vol_4d = [];
  
  for n = 1:numel(path_array)
      vol = load_untouch_nii(path_array{n});
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
      
