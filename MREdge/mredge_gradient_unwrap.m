function [x_gradient, y_gradient] = mredge_gradient_unwrap(w, prefs)
%% function mredge_gradient_unwrap(info, prefs);
%
% Part of the MREdge software package
% Created 2016 by Eric Barnhill for Charite Medical University Berlin
% Private usage only. Distribution only by permission of Elastography working
% group.
%
%
% USAGE:
%
%   unwraps the data as X and Y gradients.
%	this method has to be supported with some exceptions to the MREdge
%	file structure
%
% INPUTS:
%
%   info - MREdge acquisition info structure generated with mredge_acquisition_info
%   prefs - MREdge preferences structure generated with mredge_prefs
%
% OUTPUTS:
%
%   none

w = (w - min(w(:))) ./ (max(w(:)) - min(w(:))) * 2 * pi - pi;

if strcmp(prefs.compat,'cisnmo')
    parfor k=1:size(w,4)
        phi(:,:,:,k) = angle(smooth3(exp(1i*w(:,:,:,k)),'gaussian',[5 5 1]));
    end
else
    phi	= angle(exp(1i*double(w)));
end
[phi_x, phi_y] = gradient(exp(1i*phi));
x_gradient = imag(phi_x.*exp(-1i*phi));
y_gradient = imag(phi_y.*exp(-1i*phi));

end
