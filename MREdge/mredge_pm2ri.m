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

function mredge_pm2ri(info, frequency, component)
    acq_path = info.path;
    PHASE_SUB = fullfile(acq_path, 'Phase');
    MAG_SUB = fullfile(acq_path, 'Magnitude');
    REAL_SUB = fullfile(acq_path, 'Real');
    IMAG_SUB = fullfile(acq_path, 'Imaginary');
    path_middle = [num2str(frequency), '/', num2str(component)];
    path_filename = mredge_filename(frequency, component, '.nii.gz');
    
    % load phase and mag
    path_p = fullfile(PHASE_SUB, path_middle, path_filename);
    path_m = fullfile(MAG_SUB, path_middle, path_filename);
    
    p = load_untouch_nii(path_p);
    m = load_untouch_nii(path_m);
    
    %p = mredge_load_with_spm(path_p);
    %m = mredge_load_with_spm(path_m);
    
    % create placeholder re and im
    re = p;
    im = m;
    
    p_img = double(p.img);
    m_img = double(m.img);

    % calculate
    cplx = m_img .* exp(1i.*p_img*2*pi/(4096*2));
    re.img = real(cplx);
    im.img = imag(cplx);
    re.hdr.dime.datatype = 64;
    im.hdr.dime.datatype = 64;
   
   % write re and im
    dir_re = fullfile(REAL_SUB, path_middle);
    dir_im = fullfile(IMAG_SUB, path_middle);
    if ~exist(dir_re, 'dir')
      mkdir(dir_re);
    end
    if ~exist(dir_im, 'dir')
      mkdir(dir_im);
    end
    path_re = fullfile(dir_re, path_filename);
    path_im = fullfile(dir_im, path_filename);
    save_untouch_nii(re, path_re);
    save_untouch_nii(im, path_im);
end
