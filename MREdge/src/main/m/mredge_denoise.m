function mredge_denoise(info, prefs)
% Denoise Fourier-transformed wavefield
%
% USAGE:
%
%   mredge_denoise(info, prefs)
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
% NOTE:
%
%   If you use these denoising algorithms please cite:
%   Barnhill et al. Nonlinear Multiscale Regularization in MR Elastography
%   Med Image Anal. 2017 Jan;35:133-145. doi: 10.1016/j.media.2016.05.012
%
% Part of the MREdge software package
% Copyright (c) 2018 Eric Barnhill. All Rights Reserved
% So that we can vouch for results, 
% this code is source-available but not open source.
% Please contact Eric Barnhill at ericbarnhill@protonmail.ch 
% for permission to make modifications.
%
tic
disp('Denoising...');
mask = mredge_load_mask(info, prefs);
denoise_log_path = mredge_analysis_path(info, prefs, 'denoise_log.txt');
fileID = fopen(denoise_log_path, 'w');
fprintf(fileID, '%s \n %s \n %s \n', 'Denoise Log', string(datetime), prefs.denoise_strategy);
parfor s = 1:numel(prefs.ds.subdirs_comps_files)
  subdir = prefs.ds.subdirs_comps_files(s); %#ok<PFBNS>
  wavefield_path = cell2str(fullfile(mredge_analysis_path(info, prefs, 'ft'), subdir));
  wavefield_vol = load_untouch_nii_eb(wavefield_path);
  wavefield_img = wavefield_vol.img;
  resid_vol = wavefield_vol;
  fprintf(fileID, '%s \n', cell2str(subdir));
  if strcmpi(prefs.denoise_strategy, 'z-xy') == 1
      wavefield_img = dtdenoise_z_mad_u(wavefield_img, prefs.denoise_settings.z_thresh, prefs.denoise_settings.z_level, 1);
      wavefield_img = dtdenoise_xy_pca_mad_u(wavefield_img, prefs.denoise_settings.xy_thresh, prefs.denoise_settings.xy_level, 1, mask);
  elseif strcmpi(prefs.denoise_strategy, '3d_soft_visu') == 1
      GAIN = 1/64;
      wavefield_img = dtdenoise_3d_undec(wavefield_img, prefs.denoise_settings.full3d_level, mask, GAIN);
  elseif strcmpi(prefs.denoise_strategy, '3d_nng_visu') == 1
      wavefield_img = dtdenoise_3d_nng(wavefield_img, prefs.denoise_settings.full3d_level, mask, prefs.denoise_settings.threshold_gain);
  elseif strcmpi(prefs.denoise_strategy, '3d_ogs') == 1
      wavefield_img = dtdenoise_3d_ogs(wavefield_img, prefs.denoise_settings.full3d_level, mask);
  elseif strcmpi(prefs.denoise_strategy, '2d_soft_visu')
      wavefield_img = dtdenoise_2d_undec(wavefield_img,  prefs.denoise_settings.xy_level, mask);
      wavefield_img(isnan(wavefield_img)) = 0;
  end
  wavefield_vol.img = wavefield_img;
  resid_vol.img = resid_vol.img - wavefield_img;
  save_untouch_nii(wavefield_vol, wavefield_path);
  resid_dir = fullfile(mredge_analysis_path(info, prefs, 'denoise_resid'));
  resid_path = cell2str(fullfile(resid_dir, subdir));
  save_untouch_nii_eb(resid_vol, resid_path);
end
toc
