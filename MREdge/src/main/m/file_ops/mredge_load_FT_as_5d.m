function data_5d = mredge_load_FT_as_5d (info, prefs)
% Load Fourier-transformed wavefield into MATLAB
%
% USAGE:
%
%   data_5d = mredge_load_FT_as_5d (info, prefs)
%
% INPUTS:
%
%   info - MREdge acquisition info structure generated with mredge_acquisition_info
%   prefs - MREdge preferences structure generated with mredge_prefs
%
% OUTPUTS:
%
%   5d array of all Fourier-transformed wavefields.
%
% SEE ALSO:
%
%   mredge_save_5d_as_FT
%
% Part of the MREdge software package
% Copyright (c) 2018 Eric Barnhill. All Rights Reserved
% So that we can vouch for results, 
% this code is source-available but not open source.
% Please contact Eric Barnhill at ericbarnhill@protonmail.ch 
% for permission to make modifications.
%   
data_4d = [];
for s = 1:numel(info.ds.subdirs_comps_files)
  subdir = info.ds.subdirs_comps_files(s);
  wavefield_path = cell2str(fullfile(mredge_analysis_path(info, prefs, 'ft'), subdir));
  wavefield_vol = load_untouch_nii_eb(wavefield_path);
  wavefield_img = wavefield_vol.img;
  data_4d = cat(4, data_4d, wavefield_img);
end
sz = size(data_4d);
data_5d = reshape(data_4d, sz(1), sz(2), sz(3), 3, round(sz(4))/3);
end
