%% function mredge_save_with_spm(path)
%
% Part of the MREdge software package
% Created 2016 at Charite Medical University Berlin
% Private usage only. Distribution only by permission of Elastography working
% group.
%
% USAGE:
%
% Saves NIfTI files using SPM functions, to preserve data types etc.
% This requires  more parameters than load, because the images
% must first be saved out as 3D, then merged to 4D, then gzipped.
%
%
% INPUTS:
%
% header - SPM header file (no other!)
% image- SPM image cube
% subdir - subdirectory (e.g. 'Phase')
% series - driving frequency
% component - component of motion
%
% OUTPUTS:
%
% none

function mredge_save_4d_with_spm(header, image, subdir, series, component)
    sz = size(image);
    if numel(sz) > 4
        display('MREdge ERROR: can only save 3D and 4D volumes');
        return;
    end
    temp_file_paths = cell(sz(4), 1);
    header_path = fullfile(subdir, num2str(series), num2str(component));
    load(fullfile(header_path, 'stashed_header.mat'));
    for t = 1:sz(4)
        temp_file_name = ['temp_', num2str(t), '.nii'];
        temp_file_path = fullfile(subdir, temp_file_name);
        tempvol.name = temp_file_path;
        tempvol.dt = [4 0];
        spm_write_vol(header, tempvol);
        temp_file_paths{t} = temp_file_path;
    end
    mredge_3d_to_4d(temp_file_paths, mredge_filename(subdir, series, component, '.nii.gz'));
end
