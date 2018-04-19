function mredge_downsample(prefs)
% Downsamples phase and magnitude data
%
% INPUTS:
%
% dir - location of the time series
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
    for subdir = prefs.ds.subdirs_comps_files
        ph = load_untouch_nii_eb(cell2str(fullfile(prefs.ds.list(prefs.ds.enum.phase), subdir)));
        mag = load_untouch_nii_eb(cell2str(fullfile(prefs.ds.list(prefs.ds.enum.magnitude), subdir)));
        ph.img = ph.img(1:2:end, 1:2:end, 1:2:end);
        ph.hdr.dime.dim(2:4) = ph.hdr.dime.dim(2:4) / 2;
        mag.img = mag.img(1:2:end, 1:2:end, 1:2:end);
        mag.hdr.dime.dim(2:4) = mag.hdr.dime.dim(2:4) / 2;
        save_untouch_nii_eb(ph, cell2str(fullfile(prefs.ds.list(prefs.ds.enum.phase), subdir)));
        save_untouch_nii_eb(mag, cell2str(fullfile(prefs.ds.list(prefs.ds.enum.magnitude), subdir)));
    end
end
