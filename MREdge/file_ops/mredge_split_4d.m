function path_list = mredge_split_4d(path_4d)
%
% Part of the MREdge software package
% Created 2016 at Charite Medical University Berlin
% Private usage only. Distribution only by permission of Elastography working
% group.
%
% USAGE:
%
% Splits a 4D NIfTI into 3D images and passes the list of the 
% 3d image paths. For FSL and SPM applications.
%
% INPUTS:
%
% path_4d - path to the 4D NIfTI
%
% OUTPUTS:
%
% file_list - cell of paths to 3d files

path_base = mredge_remove_nifti_extension(path_4d);
vol_4d = load_untouch_nii_eb(path_4d);
path_list = cell(vol_4d.hdr.dime.dim(5),1);
for n = 1:size(vol_4d.img, 4)
    vol_3d = vol_4d;
    vol_3d.img = vol_4d.img(:,:,:,n);
    vol_3d.hdr.dime.dim(5) = 1;
    vol_3d.hdr.dime.dim(1) = 3;
    filename_end = sprintf("%02d", n);
    path_list{n} = [path_base, filename_end, NIF_EXT];
    save_untouch_nii(vol_3d, path_list{n});
end