%% function mredge_laplacian_unwrap(info, prefs);
%
% Part of the MREdge software package
% Created 2016 by Eric Barnhill for Charite Medical University Berlin
% Private usage only. Distribution only by permission of Elastography working
% group.
%
%
% USAGE:
%
%   unwraps data in 2, 3, or 4 dimensions using Discrete Cosine Transform
%	if you use this method, please cite:
%   Barnhill, E., Kennedy, P., Johnson, C. L., Mada, M., & Roberts, N. (2015). Real‐time 4D phase unwrapping applied to magnetic resonance elastography. Magnetic  %   resonance in medicine, 73(6), 2321-2331.
% 
%
% INPUTS:
%
%   info - MREdge acquisition info structure generated with mredge_acquisition_info
%   prefs - MREdge preferences structure generated with mredge_prefs
%
% OUTPUTS:
%
%   none

function w_u = mredge_laplacian_unwrap(w, dims)
%parse
if nargin > 1 && dims ~= 2 && dims ~= 3 && dims ~= 4
	display('MREdge ERROR: Invalid phase unwrapping dimensions.');
	return;
end
w = double(w);
phase_range = max(w(:)) - min(w(:));
if phase_range > 2*pi
	w = (w - min(w(:))) ./ (max(w(:)) - min(w(:))) *2*pi - pi;
end
sz = size(w);
w_u = zeros(sz);
if (numel(sz) < 6)
    d6 = 1;
else
    d6 = sz(6);
end
if (numel(sz) < 5)
    d5 = 1;
else
    d5 = sz(5);
end
if (numel(sz) < 4)
    d4 = 1;
else
    d4 = sz(4);
end
for f = 1:d6
    for c = 1:d5
		if dims == 4
			w_u(:,:,:,:,c,f) = unwrap(w(:,:,:,:,c,f), 4);
		else
		    for t = 1:d4
				if dims == 3
					w_u(:,:,:,t,c,f) = unwrap(w(:,:,:,t,c,f), 3);
				else 
				    for z = 1:sz(3)
				        w_u(:,:,z,t,c,f) = unwrap(w(:,:,z,t,c,f), 2);
				    end
				end
		    end
		end
    end
end

end

function w_u = unwrap(w, dims)
    sz = size(w);
    cosx = cos(w);
    sinx = sin(w);
	switch dims
		case 2
			[x, y] = meshgrid(1:sz(2), 1:sz(1));
			mask = x.^2 + y.^2;
		case 3
			[x, y, z] = meshgrid(1:sz(2), 1:sz(1), 1:sz(3));
			mask = x.^2 + y.^2 + z.^2;
		case 4
			[x, y, z, t] = meshgrid(1:sz(2), 1:sz(1), 1:sz(3), 1:sz(4));
			mask = x.^2 + y.^2 + z.^2 + t^2;
	end
    
    term1 = sinx;
    term1 = dctn(term1, dims);
    term1 = term1 .* mask;
    term1 = idctn(term1, dims);
    term1 = term1 .* cosx;
    term1 = dctn(term1, dims);
    term1 = term1 ./ mask;
    term1 = idctn(term1, dims);
    
    term2 = cosx;
    term2 = dctn(term2, dims);
    term2 = term2 .* mask;
    term2 = idctn(term2, dims);
    term2 = term2 .* sinx;
    term2 = dctn(term2, dims);
    term2 = term2 ./ mask;
    term2 = idctn(term2, dims);
    
    w_u = term1 - term2;

end