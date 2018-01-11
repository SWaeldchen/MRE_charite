function data_6d = mredge_load_magnitude_as_6d (info)
%% function mredge_laplacian_snr(info, prefs)
% Loads the magnitude (time series) MRE dasta as a 6D matlab object
% INPUTS:
%
% info - an acquisition info structure created by make_acquisition_info
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

PHASE_SUB = fullfile(info.path, 'phase');
NIF_EXT = getenv('NIFTI_EXTENSION');
data_6d = [];
for f_num = 1:numel(info.driving_frequencies)
    f = info.driving_frequencies(f_num);
    components = [];
    for c = 1:3
        path = fullfile(PHASE_SUB, num2str(f), num2str(c), mredge_filename(f, c, NIF_EXT));
        vol = load_untouch_nii_eb(path);
        img = vol.img;
        components = cat(5, components, img);
    end
    data_6d = cat(6, data_6d, components);
end