function [MREinfo] = getMREInfo(filename)
% Read MRE-relevant dicom info from the dicom file in 'filename'
%
% Syntax: mreinfo = getMREInfo(filename)
%
% The information is returned as a struct with the following fields:
% - numberOfTimesteps
% - MEGFrequency_Hz
% - vibrationFrequency_Hz
% - triggerForerun_us
% - MEGAmplitude_mT_m
% - gradientMomentNulling (the order of the highest nulled moment)
% - MEGDirections: a string indicating all encoded directions in that
% measurement
% - numberOfSlices
% - TR_ms: repetition time
% - TE_ms: echo time
% - GUIVersionNumber: for internally matching the program version to the
% sequence parameter version

% Last change: 23-11-2010
% Written by Sebastian Hirsch, sebastian.hirsch@charite.de


if (~exist(filename,'file'))
	disp(['Error: file ' filename ' does not exist.']);
	MREinfo = struct('fileCouldNotBeFound', 1);
	return;
end

fields = struct;

% double parameters:
fields.MEGAmplitude_mT_m		= 'sWiPMemBlock.adFree\[0\]';
fields.MEGFrequency_Hz			= 'sWiPMemBlock.adFree\[2\]';
fields.vibrationFrequency_Hz	= 'sWiPMemBlock.adFree\[3\]';

% long parameters:
fields.MEGDirections			= 'sWiPMemBlock.alFree\[0\]';
fields.triggerForerun_us		= 'sWiPMemBlock.alFree\[1\]';
fields.gradientMomentNulling	= 'sWiPMemBlock.alFree\[2\]';
fields.numberOfTimesteps		= 'sWiPMemBlock.alFree\[7\]';
%fields.currentPPInterval_ms		= 'sWiPMemBlock.alFree\[55\]';
%fields.lastPPInterval_ms		= 'sWiPMemBlock.alFree\[56\]';
%fields.sliceIndex				= 'sWiPMemBlock.alFree\[57\]';
%fields.currentTimestep				= 'sWiPMemBlock.alFree\[58\]';
%fields.encodingDirection		= 'sWiPMemBlock.alFree\[59\]';
%fields.timeSinceLastPulse_ms	= 'sWiPMemBlock.alFree\[60\]';
%fields.physioTriggerDelay_ms	= 'sWiPMemBlock.alFree\[61\]';
fields.GUIVersionNumber			= 'sWiPMemBlock.alFree\[62\]';

% Non-MRE parameters
fields.numberOfSlices			= 'sSliceArray.lSize';


MREinfo = struct;

inf = dicominfo(filename);


prot = char(inf.Private_0029_1020)';

f = sort(fieldnames(fields));




for q=1:size(f,1)
	currfield = f{q,1};
	regex = [getfield(fields,currfield) '\s*=\s*(\d+)'];
	t = regexp(prot, regex, 'tokens');
	
	if (isempty(t))
		MREinfo = setfield(MREinfo, currfield, 'not available');
	else
		tt = str2num(cell2mat(t{1}));
		MREinfo = setfield(MREinfo, currfield, tt);
	end
	
end

% convert MEGDirection index to a string:
switch (MREinfo.MEGDirections)
	case 'not available', % correct value would be 0, but fields with value zero are not contained in the procotol
		MREinfo.MEGDirections = 'SS';
	case 1,
		MREinfo.MEGDirections = 'PE';
	case 2,
		MREinfo.MEGDirections = 'RO';
	case 3,
		MREinfo.MEGDirections = 'SS + PE';
	case 4,
		MREinfo.MEGDirections = 'SS + RO';
	case 5,
		MREinfo.MEGDirections = 'PE + RO';
	case 6,
		MREinfo.MEGDirections = 'SS + PE + RO';
end



% if (isnumeric(MREinfo.encodingDirection))
% 	if (MREinfo.encodingDirection == 0)
% 		MREinfo.encodingDirection = 'SS';
% 	elseif (MREinfo.encodingDirection == 1)
% 		MREinfo.encodingDirection = 'PE';	
% 	elseif (MREinfo.encodingDirection == 2)
% 		MREinfo.encodingDirection = 'RO';
% 	else
% 		MREinfo.encodingDirection = 'not available';
% 	end
% end

% add non-MRE information:
MREinfo.TR_ms = inf.RepetitionTime;
MREinfo.TE_ms = inf.EchoTime;

