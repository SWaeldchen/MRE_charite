function mredge_ri2pm(info)
% Converts real and imagianry data to phase and magnitude
%
% INPUTS:
%
% dir - location of the time series
%
% OUTPUTS:
%
% none
%
% SEE ALSO:
%
%   mredge_pm2ri
%
% Part of the MREdge software package
% Created 2016 at Charite Medical University Berlin
% So that we can vouch for results, 
% this code is source-available but not open source.
% Please contact Eric Barnhill at ericbarnhill@protonmail.ch 
% for permission to make modifications.
%
    for subdir = info.ds.subdirs_comps_files
        % load re and im
        re = load_untouch_nii_eb(cell2str(fullfile(info.ds.list(info.ds.enum.real), subdir)));
        im = load_untouch_nii_eb(cell2str(fullfile(info.ds.list(info.ds.enum.imaginary), subdir)));
        % create placeholder p and m
        p = re;
        m = im;
        % calculate
        cplx = re.img + 1i*im.img;
        p.img = angle(cplx);
        m.img = abs(cplx);  
        % write p and m
        save_untouch_nii_eb(p, cell2str(fullfile(info.ds.list(info.ds.enum.phase), subdir)));
        save_untouch_nii_eb(m, cell2str(fullfile(info.ds.list(info.ds.enum.magnitude), subdir)));
    end
end
