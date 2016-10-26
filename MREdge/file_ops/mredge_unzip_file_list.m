%% function file_list = mredge_unzip_file_list(file_list)
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

function unzipped_file_list = mredge_unzip_file_list(file_list)
    unzipped_file_list = cell(size(file_list));
    for f = 1:numel(file_list)
        if exist(file_list{f}, 'file')
            gunzip(file_list{f});
            delete(file_list{f});
        end
        unzipped_file_list{f} = file_list{f}(1:end-3);
    end
end
