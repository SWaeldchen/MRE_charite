function mredge_pm2ri(info)
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

    for subdir = info.ds.subdirs_comps_files
        % load p and m
        p = load_untouch_nii_eb(cell2str(fullfile(info.ds.list(info.ds.enum.phase), subdir)));
        m = load_untouch_nii_eb(cell2str(fullfile(info.ds.list(info.ds.enum.magnitude), subdir)));
        % create placeholder re and im
        re = p;
        im = m;
        p_img = double(p.img);
        m_img = double(m.img);
        % calculate
        cplx = m_img .* exp(1i.*p_img);
        re.img = real(cplx);
        im.img = imag(cplx);
        re.hdr.dime.datatype = 64;
        im.hdr.dime.datatype = 64;
        % write re and im
        re_path = cell2str(fullfile(info.ds.list(info.ds.enum.real), subdir));
        mredge_mkdir(fileparts(re_path));
        save_untouch_nii_eb(re, re_path);
        im_path = cell2str(fullfile(info.ds.list(info.ds.enum.imaginary), subdir));
        mredge_mkdir(fileparts(im_path));
        save_untouch_nii_eb(im, im_path);
    end
