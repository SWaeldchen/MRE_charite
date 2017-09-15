%% function mredge_ri2pm(info, frequency, component)
%
% Part of the MREdge software package
% Created 2016 at Charite Medical University Berlin
% Private usage only. Distribution only by permission of Elastography working
% group.
%
% USAGE:
%
% Converts phase and magnitude .nii files to real and imaginary .nii
% and sends them to path_out/
%
%
% INPUTS:
%
% dir - location of the time series
%
% OUTPUTS:
%
% none

function mredge_ri2pm(info)
    for subdir = info.ds.subdirs_comps
        % load re and im
        re = load_untouch_nii_eb(fullfile(info.ds.list(info.ds.enum.real), subdir));
        im = load_untouch_nii_eb(fullfile(info.ds.list(info.ds.enum.imaginary), subdir));
        % create placeholder p and m
        p = re;
        m = im;
        % calculate
        cplx = re.img + 1i*im.img;
        p.img = angle(cplx)/pi*str2double(getenv(PHASE_DIVISOR));
        m.img = abs(cplx);  
        % write p and m
        save_untouch_nii(p, mredge_mkdir(fullfile(info.ds.list(info.ds.enum.phase), subdir)));
        save_untouch_nii(m, mredge_mkdir(fullfile(info.ds.list(info.ds.enum.magnitude), subdir)));
    end
end
