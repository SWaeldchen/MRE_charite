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
    parfor s = 1:numel(info.ds.subdirs_comps)
      subdir = info.ds.subdirs_comps(s);
      wavefield_path = cell2str(fullfile(mredge_analysis_path(info, prefs, 'FT'), subdir));
      wavefield_vol = load_untouch_nii_eb(wavefield_path);
      wavefield_img = wavefield_vol.img;
      resid_vol = wavefield_vol;
      if strcmpi(prefs.denoise_strategy, 'z-xy') == 1
          wavefield_img = dtdenoise_xy_pca_mad_u(wavefield_img, prefs.denoise_settings.xy_thresh_factor, prefs.denoise_settings.xy_level, 1, mask);
      elseif strcmpi(prefs.denoise_strategy, '3d_soft_visu') == 1
          wavefield_img = dtdenoise_3d_undec(wavefield_img, prefs.denoise_settings.full3d_level, mask);
      elseif strcmpi(prefs.denoise_strategy, '3d_ogs') == 1
          wavefield_img = dtdenoise_3d_mad_ogs_undec(wavefield_img, prefs.denoise_settings.full3d_level, mask);
      elseif strcmpi(prefs.denoise_strategy, '2d')
          wavefield_img = dtdenoise_2d_undec(wavefield_img,  prefs.denoise_settings.xy_level, mask);
          wavefield_img(isnan(wavefield_img)) = 0;
      elseif strcmpi(prefs.denoise_strategy, 'lowpass')|| strcmpi(prefs.denoise_strategy, 'lopass')
          if prefs.lowpass_settings.dimensions == 2
              if strcmpi(prefs.lowpass_settings.cutoff_unit, 'norm')
                  for z=1:size(wavefield_img,3)
                     wavefield_img(:,:,z) = butter_2d(prefs.lowpass_settings.order, prefs.lowpass_settings.cutoff, wavefield_img(:,:,z));
                  end
              elseif strcmpi(prefs.lowpass_settings.cutoff_unit, 'wpm')
                  wpm = prefs.lowpass_settings.cutoff;
                  for z=1:size(wavefield_img,3)
                     wavefield_img(:,:,z) = uh_filtspatio2d(wavefield_img(:,:,z),[info.voxel_spacing(1); info.voxel_spacing(2)],prefs.lowpass_settings.cutoff,1,0,5, 'bwlow', 0);
                  end
              else
                  disp('MREdge ERROR: lowpass units not recognized');
              end
          else
              wavefield_img = butter_3d(prefs.lowpass_settings.order, prefs.lowpass_settings.cutoff, wavefield_img);
          end
      end
      wavefield_vol.img = wavefield_img;
      resid_vol.img = resid_vol.img - wavefield_img;
      save_untouch_nii(wavefield_vol, wavefield_path);
      resid_dir = fullfile(mredge_analysis_path(info, prefs, 'denoise_resid'));
      resid_path = cell2str(fullfile(resid_dir, subdir));
      save_untouch_nii_eb(resid_vol, resid_path);
    end
end


