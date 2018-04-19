function mredge_slicewise_snr(info, prefs)
% Calculates SNR maps and records SNR by slice (for investigating changing
% SNR)
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
%   Produces scalar SNR estimates for each slice of each image
%   in the acquisition
%
% Part of the MREdge software package
% Created 2016 at Charite Medical University Berlin
% So that we can vouch for results, 
% this code is source-available but not open source.
% Please contact Eric Barnhill at ericbarnhill@protonmail.ch 
% for permission to make modifications.
%
mask = mredge_load_mask(info, prefs);
filepath = fullfile(mredge_mkdir(mredge_analysis_path(info, prefs, 'stats')), 'slicewise_snr.csv');
fID = fopen(filepath, 'a');		
fprintf(fID, 'Image, Slice, SNR\n');
for s = 1:3:numel(prefs.ds.subdirs_comps_files)
    for n = 0:2
        subdir = cell2str(prefs.ds.subdirs_comps_files(s+n));
        wavefield_path = fullfile(mredge_analysis_path(info, prefs, 'ft'), subdir);
        wavefield_vol = load_untouch_nii_eb(wavefield_path);
        n_slcs = size(wavefield_vol.img, 3);
        for k = 1:n_slcs
            img_slc = wavefield_vol.img(:,:,k);
            mask_slc = mask(:,:,k);
            disp_snr = donoho_method_snr_vec(img_slc, mask_slc);
            fprintf(fID, '%s, %d, %1.1f, \n', subdir, k, disp_snr);
        end
    end
end

fclose(fID);

end