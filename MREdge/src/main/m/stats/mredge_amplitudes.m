function mredge_amplitudes(info, prefs, freq_indices)
% Creates summed amplitude images
%
% INPUTS:
%
% info - an acquisition info structure created by make_acquisition_info
% prefs - mredge preferences file
%
% OUTPUTS:
%
% none
%
% Part of the MREdge software package
% Created 2016 at Charite Medical University Berlin
% So that we can vouch for results, 
% this code is source-available but not open source.
% Please contact Eric Barnhill at ericbarnhill@protonmail.ch 
% for permission to make modifications.
%
ft = mredge_analysis_path(info, prefs, 'ft');
amp = [];
for f_ind = 1:numel(freq_indices)
    f = info.driving_frequencies(f_ind);
    % make use of component order in prefs
    components = cell(3,1);
    for c = 1:3
        wavefield_path = fullfile(ft, num2str(f), num2str(c), mredge_filename(f, c));
        wavefield_vol = load_untouch_nii_eb(wavefield_path);
        components{c} = double(wavefield_vol.img);
    end
    if isempty(amp)
        amp_vol = wavefield_vol;
        amp_vol.hdr.dime.datatype = 64;
        amp_vol.img = zeros(size(amp_vol.img));
    end
    amp_vol.img = amp_vol.img + abs(components{1}) + abs(components{2}) + abs(components{3});
end
amp_folder = mredge_analysis_path(info, prefs, 'amp');
if ~exist(amp_folder, 'dir')
    mkdir(amp_folder);
end
amp_path = fullfile(amp_folder, mredge_freq_indices_to_filename(info,prefs,freq_indices));
save_untouch_nii(amp_vol, amp_path);
end
