%% function mredge_rer_3d(vol)
%
% Part of the MREdge software package
% Created 2016 at Charite Medical University Berlin
% Private usage only. Distribution only by permission of Elastography working
% group.
%
% USAGE:
%
% Measures Reduced Energy Ratio for 3D volumes,
% using the 2D method in the paper found in
% Lee, S. Y., Yoo, J. T., Kumar, Y., & Kim, S. W. (2009). 
% Reduced energy-ratio measure for robust autofocusing in digital camera. 
% IEEE Signal Processing Letters, 16(2), 133-136.
%
% Also uses code from fmeasure, Said Pertuz, 2016, found at:
% http://www.mathworks.com/matlabcentral/fileexchange/27314-focus-measure/content/fmeasure/fmeasure.m
%
%
%
% INPUTS:
%
% dir - location of the time series
%
% OUTPUTS:
%
% none

function [rer_vol] = mredge_rer_3d(vol)
    sz = size(vol);
    rer_vol = zeros(sz);
    parfor n = 1:sz(3)
        rer_vol(:,:,n) = rer_slice(vol(:,:,n));
    end
end

function slice_rer = rer_slice(slice)
	slice_rer = zeros(size(slice));
	sz = size(slice);
	for i = 1:sz(1)-8
		for j = 1:sz(2)-8
			window = slice(i:i+7, j:j+7);
			win_dct = dct2(window);
			slice_rer(i+3,j+3) = (win_dct(1,2)^2+win_dct(1,3)^2+win_dct(2,1)^2+win_dct(2,2)^2+win_dct(3,1)^2)/(win_dct(1,1)^2);
		end
	end
end
