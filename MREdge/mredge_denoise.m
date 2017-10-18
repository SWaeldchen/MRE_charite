function mredge_denoise(info, prefs)
%
% Part of the MREdge software package
% Created 2016 by Eric Barnhill for Charite Medical University Berlin
% Private usage only. Distribution only by permission of Elastography working
% group.
%
%
% USAGE:
%
%   Deonise the complex wave field.
%
% INPUTS:
%
%   info - MREdge acquisition info structure generated with mredge_acquisition_info
%   prefs - MREdge preferences structure generated with mredge_prefs
%
% OUTPUTS:
%
%   none
    mask = mredge_load_mask(info, prefs);
    denoise_log_path = mredge_analysis_path(info, prefs, 'denoise_log.txt');
    fileID = fopen(denoise_log_path, 'w');
    fprintf(fileID, '%s \n %s \n %s \n', 'Denoise Log', string(datetime), prefs.denoise_strategy);
    parfor s = 1:numel(info.ds.subdirs_comps_files)
      subdir = info.ds.subdirs_comps_files(s);
      wavefield_path = cell2str(fullfile(mredge_analysis_path(info, prefs, 'FT'), subdir));
      wavefield_vol = load_untouch_nii_eb(wavefield_path);
      wavefield_img = wavefield_vol.img;
      resid_vol = wavefield_vol;
      fprintf(fileID, '%s \n', cell2str(subdir));
      if strcmpi(prefs.denoise_strategy, 'z-xy') == 1
          wavefield_img = dtdenoise_z_mad_u(wavefield_img, prefs.denoise_settings.z_thresh, prefs.denoise_settings.z_level, 1);
          wavefield_img = dtdenoise_xy_pca_mad_u(wavefield_img, prefs.denoise_settings.xy_thresh, prefs.denoise_settings.xy_level, 1, mask);
      elseif strcmpi(prefs.denoise_strategy, '3d_soft_visu') == 1
          wavefield_img = dtdenoise_3d_undec(wavefield_img, prefs.denoise_settings.full3d_level, mask, prefs.denoise_settings.threshold_gain);
      elseif strcmpi(prefs.denoise_strategy, '3d_ogs') == 1
          wavefield_img = dtdenoise_3d_mad_ogs_undec_log(wavefield_img, prefs.denoise_settings.full3d_thresh, prefs.denoise_settings.full3d_level, mask, fileID, prefs.base1, prefs.base2);
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
end


