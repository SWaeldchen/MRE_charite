function mredge_organize_acquisition(info)
%
% Part of the MREdge software package
% Created 2016 at Charite Medical University Berlin
% Private usage only. Distribution only by permission of Elastography working
% group.
%
% USAGE:
%
% Processes NIfTI files into appropriate folders
%
% INPUTS:
%
% info - an acquisition info structure created by make_acquisition_info
%
% OUTPUTS:
%
% none

%% process each series
NIF_EXT = getenv('NIFTI_EXTENSION');

for d = 1:numel(info.ds.logical)
    if info.ds.logical(d) 
        dirpath = fullfile(info.ds.list{d});
        if ~exist(dirpath, 'dir')
            mkdir(dirpath);
        end
        series_num = info.ds.series_nums{d};
        movefile(fullfile(info.path, [num2str(series_num), NIF_EXT]), dirpath);
    end
end
    
if info.all_freqs_one_series == 1
    mredge_break_into_frequencies(info.phase(1), info.ds.list(info.ds.enum.phase), info);
    mredge_break_into_frequencies(info.magnitude(1), info.ds.list(info.ds.enum.magnitude), info);
else
    mredge_rename_by_frequency(info.ds.list(info.ds.enum.phase), info.phase, info);
    mredge_rename_by_frequency(info.ds.list(info.ds.enum.magnitude), info.magnitude, info);
end

mredge_phase2double(info);
mredge_mag2double(info);
delete(fullfile(info.path, '*.nii'));
