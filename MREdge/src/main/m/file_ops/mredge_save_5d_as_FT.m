function mredge_save_5d_as_FT (data_5d, info, prefs)
% Save 5d MATLAB object as Fourier-transformed wavefield
%
% INPUTS:
%
%   data_5d - 5d MATLAB object matching frequency specifications in info
%   info - MREdge acquisition info structure generated with mredge_acquisition_info
%   prefs - MREdge preferences structure generated with mredge_prefs
%
% OUTPUTS:
%
%   none
%
% SEE ALSO:
%
%   mredge_load_FT_as_5d
%
% Part of the MREdge software package
% Copyright (c) 2018 Eric Barnhill. All Rights Reserved
% So that we can vouch for results, 
% this code is source-available but not open source.
% Please contact Eric Barnhill at ericbarnhill@protonmail.ch 
% for permission to make modifications.
%   
ft = mredge_analysis_path(info, prefs, 'ft');
num_freqs = numel(info.driving_frequencies);
for f_num = 1:num_freqs
    f = info.driving_frequencies(f_num);
    for c = 1:3
        path = fullfile(ft, num2str(f), num2str(c), mredge_filename(f, c));
        vol = load_untouch_nii_eb(path);
        vol.img = data_5d(:,:,:,c,f_num);
        save_untouch_nii(vol, path);
    end
end
