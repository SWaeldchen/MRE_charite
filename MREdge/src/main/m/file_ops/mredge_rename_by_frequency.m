function mredge_rename_by_frequency(subdir, series_numbers, info)
% For acquisitions where each frequency has its own series number, rename each series to its corresponding frequency
%
% INPUTS:
%
%   series_number - number of series. should be entire file name produced by dcm2niix
%   subdir - path of subdir that will contain this series (e.g. 'Phase')
%   info - acquisition info 
%
% OUTPUTS:
%
%   none
%
% SEE ALSO:
%
%   mredge_organize_acquistiion, mredge_break_into_frequencies
%
% Part of the MREdge software package
% Created 2016 at Charite Medical University Berlin
% So that we can vouch for results, 
% this code is source-available but not open source.
% Please contact Eric Barnhill at ericbarnhill@protonmail.ch 
% for permission to make modifications.
%
NIF_EXT = getenv('NIFTI_EXTENSION');
TIME_STEPS = info.time_steps;
n_freqs = numel(info.driving_frequencies);
for f = 1:n_freqs
    nifti_4d_path = fullfile(cell2str(subdir), [num2str(series_numbers(f)), NIF_EXT]);
    nifti_4d_vol = load_untouch_nii_eb(nifti_4d_path);
    for c = 1:3
        index = TIME_STEPS*(c-1) + 1;
        sub_vol = nifti_4d_vol;
        sub_vol.hdr.dime.dim(5) = TIME_STEPS;
        sub_vol.img = sub_vol.img(:,:,:,index:index+TIME_STEPS-1);
        component_dir = fullfile(cell2str(subdir), num2str(info.driving_frequencies(f)), num2str(c));
        if ~exist(component_dir, 'dir')
            mkdir(component_dir);
        end
        save_untouch_nii(sub_vol, fullfile(component_dir, mredge_filename(info.driving_frequencies(f), c, NIF_EXT)));
    end
end
    
