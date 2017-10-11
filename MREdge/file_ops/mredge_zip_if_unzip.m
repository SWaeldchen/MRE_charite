%% function zip = mredge_zip_if_unzip(unzip)

%
% Part of the MREdge software package
% Created 2016 at Charite Medical University Berlin
% Private usage only. Distribution only by permission of Elastography working
% group.
%
% USAGE:
%
% Zips nifti if it is unzipped. For navigation between FSL and other packages.
%
% INPUTS:
%
% unzip - zipped file path
%
% OUTPUTS:
%
% zip - unzipped file path

function zip = mredge_zip_if_unzip(unzip)

zip = [unzip, '.gz'];

if exist(unzip, 'file')
	gzip(unzip);
    delete(unzip);
end


