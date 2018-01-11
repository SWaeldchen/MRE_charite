function mredge_invert(info, prefs, freq_indices)
% Wave inversion of preprocessed MRE data
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
ft = mredge_analysis_path(info, prefs, 'ft');
wavefields = [];
for f_ind = 1:numel(freq_indices)
    f = info.driving_frequencies(f_ind);
    wavefield =[];
    for c = 1:3
        comp_path = fullfile(ft, num2str(f), num2str(c), mredge_filename(f, c));
        wavefield_comp_vol = load_untouch_nii_eb(comp_path);
        % create dummy nifti for results
        if isempty(wavefield)
            dummy = wavefield_comp_vol;
        end
        wavefield = cat(4, wavefield, wavefield_comp_vol.img);
    end
    wavefields = cat(5, wavefields, wavefield);
end
filename = mredge_freq_indices_to_filename(info, prefs, freq_indices);
if strcmpi(prefs.inversion_strategy, 'mdev')
    [absg, phi] = helm_inv_phi(wavefields, info.driving_frequencies(freq_indices), ...
        info.voxel_spacing);
    absg_vol = dummy;
    absg_vol.img = absg;
    absg_vol.hdr.dime.datatype = 64;
    absg_path = fullfile(mredge_analysis_path(info, prefs, 'absg'), filename);
    save_untouch_nii_eb(absg_vol, absg_path);
    phi_vol = dummy;
    phi_vol.img = phi;
    phi_vol.hdr.dime.datatype = 64;
    phi_path = fullfile(mredge_analysis_path(info, prefs, 'phi'), filename);
    save_untouch_nii_eb(phi_vol, phi_path);   
elseif strcmpi(prefs.inversion_strategy, 'sfwi')
    sfwi = sfwi_inversion(wavefields, info.driving_frequencies(freq_indices), ... 
        info.voxel_spacing, [1 2 3], 1);
    sfwi_vol = dummy;
    sfwi_vol.img = sfwi;
    sfwi_path = fullfile(mredge_analysis_path(info, prefs,  'sfwi'), filename);
    save_untouch_nii_eb(sfwi_vol, sfwi_path);
elseif strcmpi(prefs.inversion_strategy, 'fv')
    fv = fv_invert_2(wavefields, info.driving_frequencies(freq_indices), info.voxel_spacing);
    fv_vol = dummy;
    fv_vol.img = fv;
    fv_path = fullfile(mredge_analysis_path(info, prefs,  'fv'), filename);
    save_untouch_nii_eb(fv_vol, fv_path);
else
    disp('MREdge ERROR: unknown inversion strategy. No inversion performed');
end


