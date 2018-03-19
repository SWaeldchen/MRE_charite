function mredge_denoise_raw(info, prefs)
% Denoises raw complex data prior to phase unwrapping
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
% Part of the MREdge software package
% Copyright (c) 2018 Eric Barnhill. All Rights Reserved
% So that we can vouch for results, 
% this code is source-available but not open source.
% Please contact Eric Barnhill at ericbarnhill@protonmail.ch 
% for permission to make modifications.
%
tic
disp('Raw data denoise');
mredge_pm2ri(info);
parfor s = 1:numel(prefs.ds.subdirs_comps_files)
    subdir = prefs.ds.subdirs_comps_files(s); %#ok<PFBNS>
    real_path = cell2str(fullfile(prefs.ds.list(prefs.ds.enum.real), subdir));
    real = load_untouch_nii_eb(real_path);
    imag_path = cell2str(fullfile(prefs.ds.list(prefs.ds.enum.imaginary), subdir));
    imag = load_untouch_nii_eb(imag_path);
    if strcmpi(prefs.denoise_strategy, '2d_raw') %#ok<PFBNS>
        real.img = den_2d_preunwrap(real.img);
        imag.img = den_2d_preunwrap(imag.img);
    end
    save_untouch_nii_eb(real, real_path);
    save_untouch_nii_eb(imag, imag_path);
end
mredge_ri2pm(info);
toc