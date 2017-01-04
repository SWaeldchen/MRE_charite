%% function unzip = mredge_unzip_if_zip(zip)

%
% Part of the MREdge software package
% Created 2016 at Charite Medical University Berlin
% Private usage only. Distribution only by permission of Elastography working
% group.
%
% USAGE:
%
% Unzips nifti if it is zipped. For navigation between SPM and other packages.
%
% INPUTS:
%
% zip - zipped file path
%
% OUTPUTS:
%
% unzip - unzipped file path

function unzip = mredge_unzip_if_zip(zip)


if strcmp(zip(end-1:end), 'gz') == 1 && exist(zip, 'file')
    unzip = zip(1:end-3);
	gunzip(zip);
else
    unzip = zip;
end
