function mredge_pm2ri(prefs)
% Converts phase and magnitude data to real and imaginary data for processing of complex MR signal
%
% INPUTS:
%
% info - MREdge info struct
%
% OUTPUTS:
%
% none
%
% SEE ALSO:
%
%   mredge_ri2pm
%
% Part of the MREdge software package
% Created 2016 at Charite Medical University Berlin
% So that we can vouch for results, 
% this code is source-available but not open source.
% Please contact Eric Barnhill at ericbarnhill@protonmail.ch 
% for permission to make modifications.
%
PHASE_RANGE = 4096;
for subdir = prefs.ds.subdirs_comps_files
    % load p and m
    p = load_untouch_nii_eb(cell2str(fullfile(prefs.ds.list(prefs.ds.enum.phase), subdir)));
    m = load_untouch_nii_eb(cell2str(fullfile(prefs.ds.list(prefs.ds.enum.magnitude), subdir)));
    % create placeholder re and im
    re = m;
    im = m;
    p_img = double(p.img) / PHASE_RANGE * 2 *pi;
    m_img = double(m.img);
    % calculate
    cplx = m_img .* exp(1i.*p_img);
    re.img = real(cplx);
    im.img = imag(cplx);
    re.hdr.dime.datatype = 64;
    im.hdr.dime.datatype = 64;
    % write re and im
    re_path = cell2str(fullfile(prefs.ds.list(prefs.ds.enum.real), subdir));
    mredge_mkdir(fileparts(re_path));
    im_path = cell2str(fullfile(prefs.ds.list(prefs.ds.enum.imaginary), subdir));
    mredge_mkdir(fileparts(im_path));
    save_untouch_nii_eb(re, re_path);
    save_untouch_nii_eb(im, im_path);
end
