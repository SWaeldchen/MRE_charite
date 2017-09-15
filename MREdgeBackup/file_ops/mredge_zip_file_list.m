%% function file_list = mredge_zip_file_list(file_list)
%
% Part of the MREdge software package
% Created 2016 at Charite Medical University Berlin
% Private usage only. Distribution only by permission of Elastography working
% group.
%
% USAGE:
%
% Uses FSL split to split a 4D .nii.gz file into a file list. Default
% format is 'vol0000.nii.gz', 'vol0001.nii.gz', etc.%
%
% INPUTS:
%
% file_list - cell list with paths to .gz files
%
% OUTPUTS:
%
% unzipped_file_list - cell of paths to unzipped files

function zipped_file_list = mredge_zip_file_list(unzipped_file_list)
    zipped_file_list = cell(size(unzipped_file_list));
    for f = 1:numel(unzipped_file_list)
        gzip(unzipped_file_list{f});
        zipped_file_list{f} = [unzipped_file_list{f}, '.gz'];
        delete(unzipped_file_list{f});
    end
end
