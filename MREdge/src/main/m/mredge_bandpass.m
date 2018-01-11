function mredge_bandpass(info, prefs)
% Applies highpass and lowpass butterworth filters if they are set in prefs
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
mask = mredge_load_mask(info, prefs);
parfor s = 1:numel(info.ds.subdirs_comps_files)
    subdir = info.ds.subdirs_comps_files(s);
    wavefield_path = cell2str(fullfile(mredge_analysis_path(info, prefs, 'ft'), subdir));
    wavefield_vol = load_untouch_nii_eb(wavefield_path);
    wavefield_img = wavefield_vol.img;
    resid_vol = wavefield_vol;
    if prefs.lowpass
        if prefs.lowpass_settings.dimensions == 2
            for z=1:size(wavefield_img,3)
               wavefield_img(:,:,z) = butter_2d(prefs.lowpass_settings.order, prefs.lowpass_settings.cutoff, wavefield_img(:,:,z));
            end
        elseif prefs.lowpass_settings.dimensions == 3
            wavefield_img = butter_3d(prefs.lowpass_settings.order, prefs.lowpass_settings.cutoff, wavefield_img);
        end
    end
    if prefs.highpass
        if prefs.lowpass_settings.dimensions == 2
            for z=1:size(wavefield_img,3)
               wavefield_img(:,:,z) = butter_2d(prefs.highpasspass_settings.order, prefs.highpass_settings.cutoff, wavefield_img(:,:,z), 1);
            end
        elseif prefs.lowpass_settings.dimensions == 3
            wavefield_img = butter_3d(prefs.highpass_settings.order, prefs.highpass_settings.cutoff, wavefield_img, 1);
        end
    end
    wavefield_vol.img = wavefield_img;
    resid_vol.img = resid_vol.img - wavefield_img;
    save_untouch_nii(wavefield_vol, wavefield_path);
    resid_dir = fullfile(mredge_analysis_path(info, prefs, 'bandpass_resid'));
    resid_path = cell2str(fullfile(resid_dir, subdir));
    save_untouch_nii_eb(resid_vol, resid_path);
end
