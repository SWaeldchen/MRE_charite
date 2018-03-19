function mredge_transpose_images(info, prefs, freq_indices)
% Transposes magnitude and viscoelastic parameter images to improve SPM coregistration.
%
% USAGE:
%
%   mredge_transpose_images(info, prefs)
%
% INPUTS:
%
%   info - MREdge acquisition info structure generated with mredge_acquisition_info
%   prefs - MREdge preferences structure generated with mredge_prefs
%
% OUTPUTS:
%
%   none
%
% SEE ALSO:
%
%   mredge_brain_analysis
%
% Part of the MREdge software package
% Copyright (c) 2018 Eric Barnhill. All Rights Reserved
% So that we can vouch for results, 
% this code is source-available but not open source.
% Please contact Eric Barnhill at ericbarnhill@protonmail.ch 
% for permission to make modifications.
%

NIF_EXT = getenv('NIFTI_EXTENSION');
HDR_TEMPLATE = '/home/ericbarnhill/Documents/MATLAB/ericbarnhill/projects/2018-03-12-virchow/hdr_template.nii';
hdr_template = load_untouch_nii(HDR_TEMPLATE);
avg_sub = mredge_analysis_path(info,prefs, 'magnitude');
avg_path = fullfile(avg_sub, ['avg_magnitude', NIF_EXT]);
avg_vol = load_untouch_nii_eb(avg_path);
avg_vol_t = avg_vol;
%avg_vol_t.img  = flipud(permute(avg_vol_t.img, [2 1 3]));
%avg_vol_t.hdr.dime.dim([2 3]) = avg_vol_t.hdr.dime.dim([3 2]);
avg_vol_t.hdr.hist = hdr_template.hdr.hist;
filename_h = fullfile(avg_sub, ['h_avg_magnitude', NIF_EXT]);
filename_t = fullfile(avg_sub, ['t_avg_magnitude', NIF_EXT]);
%save_untouch_nii(avg_vol_t, filename_t);
save_untouch_nii(avg_vol_t, filename_h);
reslice_nii(filename_h, filename_t);

if prefs.inversion_strategy == 'mdev'
    param_names = {'absg', 'phi'};
else
    param_names = {prefs.inversion_strategy};
end

filename = mredge_freq_indices_to_filename(info, prefs, freq_indices);
for param_name = param_names
    param_path = cell2str(fullfile(mredge_analysis_path(info, prefs, param_name), filename));
    param_vol = load_untouch_nii_eb(param_path);
    param_vol_t = avg_vol_t;
    param_vol_t.img = param_vol.img;
    %param_vol_t.img = flipud(permute(param_vol.img, [2 1 3]));
    filename_h = cell2str(fullfile(mredge_analysis_path(info, prefs, param_name), ['h_', filename]));
    filename_t = cell2str(fullfile(mredge_analysis_path(info, prefs, param_name), ['t_', filename]));
    %save_untouch_nii(param_vol_t, filename_t);
    save_untouch_nii(param_vol_t, filename_h);   
    reslice_nii(filename_h, filename_t);
end

end
