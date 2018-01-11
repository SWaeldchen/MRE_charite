function mredge_snr(info, prefs)
% Calculates SNR maps and records SNR values in stats folder
%
% INPUTS:
%
%   info - an acquisition info structure created by make_acquisition_info
%   prefs - mredge preferences file
%
% OUTPUTS:
%
%   none
%
% NOTE:
%
%   Produces vectorial SNR estimates for displacement and Laplacian fields,
%   and scalar SNR estimate for Octahedral Shear Strain. Calculates 
%   SNR results at each frequency independently.
%
% Part of the MREdge software package
% Created 2016 at Charite Medical University Berlin
% So that we can vouch for results, 
% this code is source-available but not open source.
% Please contact Eric Barnhill at ericbarnhill@protonmail.ch 
% for permission to make modifications.
%
mask = mredge_load_mask(info, prefs);
nfreqs = numel(info.driving_frequencies);
disp_snr = zeros(nfreqs, 1);
strain_snr = zeros(nfreqs, 1);
lap_snr = zeros(nfreqs, 1);
tally = 0;
for s = 1:3:numel(info.ds.subdirs_comps_files)
    tally = tally + 1;
    wavefield_img = [];
    for n = 0:2
        subdir = info.ds.subdirs_comps_files(s+n);
        wavefield_path = cell2str(fullfile(mredge_analysis_path(info, prefs, 'ft'), subdir));
        wavefield_vol = load_untouch_nii_eb(wavefield_path);
        wavefield_img = cat(4, wavefield_img, wavefield_vol.img);
    end
    [disp_snr(tally), strain_snr(tally), lap_snr(tally)] = mre_snr(wavefield_img, info.voxel_spacing, mask);
end
filepath = fullfile(mredge_mkdir(mredge_analysis_path(info, prefs, 'stats')), 'snr_measures.csv');
fID = fopen(filepath, 'w');		
fprintf(fID, 'Frequency, Displacement, Strain, Laplacian\n');
for f = 1:nfreqs
    %disp([num2str(stable_frequencies(f)), 'Hz']);
    fprintf(fID, '%1.1f, %1.3f, %1.3f, %1.3f \n', info.driving_frequencies(f), disp_snr(f), strain_snr(f), lap_snr(f));
end
fclose(fID);

end