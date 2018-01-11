function zip = mredge_zip_if_unzip(unzip)
% Zips nifti if it is unzipped. For navigation between FSL, SPM and other packages
%
% INPUTS:
%
%   unzip - zipped file path
%
% OUTPUTS:
%
%   zip - unzipped file path
%
% Part of the MREdge software package
% Created 2016 at Charite Medical University Berlin
% So that we can vouch for results, 
% this code is source-available but not open source.
% Please contact Eric Barnhill at ericbarnhill@protonmail.ch 
% for permission to make modifications.
%
zip = [unzip, '.gz'];

if exist(unzip, 'file')
	gzip(unzip);
    delete(unzip);
end


