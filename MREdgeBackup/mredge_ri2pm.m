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

function mredge_ri2pm(info, frequency, component)
    NIFTI_EXTENSION = getenv('NIFTI_EXTENSION');
    acq_path = info.path;
    PHASE_SUB = fullfile(acq_path, 'Phase');
    MAG_SUB = fullfile(acq_path, 'Magnitude');
    REAL_SUB = fullfile(acq_path, 'Real');
    IMAG_SUB = fullfile(acq_path, 'Imaginary');
    path_middle = [num2str(frequency), '/', num2str(component)];
    path_filename = mredge_filename(frequency, component, NIFTI_EXTENSION);
    
    % load re and im
    path_re = fullfile(REAL_SUB, path_middle, path_filename);
    path_im = fullfile(IMAG_SUB, path_middle, path_filename);
    re = load_untouch_nii_eb(path_re);
    im = load_untouch_nii_eb(path_im);
    
    % create placeholder p and m
    p = re;
    m = im;
    
    re_img = double(re.img);
    im_img = double(im.img);
   
    % calculate
    cplx = re_img + 1i*im_img;
    p.img = angle(cplx)/pi*4096;
    m.img = abs(cplx);
    %p.hdr.dime.datatype = 4;
    %m.hdr.dime.datatype = 4;
   
    % write p and m
    dir_p = fullfile(PHASE_SUB, path_middle);
    dir_m = fullfile(MAG_SUB, path_middle);
    if ~exist(dir_p, 'dir')
      mkdir(dir_p);
    end
    if ~exist(dir_m, 'dir')
      mkdir(dir_m);
    end
    path_p = fullfile(dir_p, path_filename);
    path_m = fullfile(dir_m, path_filename);
    save_untouch_nii(p, path_p);
    save_untouch_nii(m, path_m);
end
