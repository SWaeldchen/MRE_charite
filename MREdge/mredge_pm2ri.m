%% function mredge_pm2ri(info, frequency, component)
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

function mredge_pm2ri(info)
    for subdir = info.ds.subdirs_comps
        % load p and m
        p = load_untouch_nii_eb(fullfile(info.ds.list(info.ds.enum.phase), subdir));
        m = load_untouch_nii_eb(fullfile(info.ds.list(indo.ds.enum.magnitude), subdir));
        % create placeholder re and im
        re = p;
        im = m;
        p_img = double(p.img);
        m_img = double(m.img);
        % calculate
        cplx = m_img .* exp(1i.*p_img*2*pi/(4096));
        re.img = real(cplx);
        im.img = imag(cplx);
        re.hdr.dime.datatype = 64;
        im.hdr.dime.datatype = 64;
        % write re and im
        save_untouch_nii(re, mredge_mkdir(fullfile(info.ds.list(info.ds.enum.real), subdir)));
        save_untouch_nii(im, mredge_mkdir(fullfile(info.ds.list(info.ds.enum.imaginary), subdir)));
    end
end
