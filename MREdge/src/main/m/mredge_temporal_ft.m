function mredge_temporal_ft(info, prefs)
% Temporally Fourier-transforms the complex wave field
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
for subdir = prefs.ds.subdirs_comps_files
    time_series_path = cell2str(fullfile(prefs.ds.list(prefs.ds.enum.phase), subdir));
    time_series_vol = load_untouch_nii_eb(time_series_path);
    % make dummy complex 3d volume
    ft_vol = time_series_vol;
    ft_vol.hdr.dime.datatype = 32;
    ft_vol.hdr.dime.dim(1) = 3;
    ft_vol.hdr.dime.dim(5) = 1;
    % call functionality here
    phase_ft = fft(double(time_series_vol.img), [],  4);
    ft_vol.img = phase_ft(:,:,:,prefs.fft_bin);
    save_path = fullfile(mredge_analysis_path(info, prefs, 'ft'), cell2str(subdir));
    save_untouch_nii_eb(ft_vol, save_path);
end


