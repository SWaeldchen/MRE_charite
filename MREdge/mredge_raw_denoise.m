function mredge_raw_denoise(info, prefs)
%
% Part of the MREdge software package
% Created 2016 by Eric Barnhill for Charite Medical University Berlin
% Private usage only. Distribution only by permission of Elastography working
% group.
%
%
% USAGE:
%
%   denoises raw complex data prior to phase unwrapping
%
% INPUTS:
%
%   info - MREdge acquisition info structure generated with mredge_acquisition_info
%   prefs - MREdge preferences structure generated with mredge_prefs
%
% OUTPUTS:
%
%   none

mredge_pm2ri(info, prefs);
parfor s = 1:numel(info.ds.subdirs_comps_files)
    subdir = info.ds.subdirs_comps_files(s);
    real_path = cell2str(fullfile(info.ds.list(info.ds.enum.real), subdir));
    real = load_untouch_nii_eb(real_path);
    imag_path = cell2str(fullfile(info.ds.list(info.ds.enum.imaginary), subdir));
    imag = load_untouch_nii_eb(imag_path);
    if strcmpi(prefs.denoise_strategy, '2d_raw')
        real.img = den_2d_preunwrap(real.img);
        imag.img = den_2d_preunwrap(imag.img);
    end
    save_untouch_nii_eb(real, real_path);
    save_untouch_nii_eb(imag, imag_path);
end
mredge_ri2pm(info, prefs);
 
    

end
