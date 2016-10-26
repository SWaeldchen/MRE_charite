function [U, snr] = get_MRE_FT(U, unwrapped)
%%
% 
%
% ESP (Elastography Software Pipeline) Inversion Software
% Developed by Eric Barnhill at the University of Edinburgh
% in collaboration with Charité Universitätsmedizin Berlin
%
% Alpha version 0.1 Privately distributed to testers
% Please do not share yet
% (c) 2014 All Rights Reserved
%
% This software performs Multifrequency Dual Parameter Elastovisco (MDEV)
% Inversion on MR Elastography Phase Images including:
%   - Phase Unwrapping
%   - Sparsity-based Denoising
%   - Multi-scale Super-resolution Inversion
%
% Results are two variables of the complex modulus: |G*|, and phi.
% G' can be obtained by mag*cos(phi) and G'' can be obtained by
% mag*sin(phi), if preferred.
%
% Before you begin, alter line 42 to have the correct path for ESP.jar .
% For best performance, go to Matlab preferences and max out your
% Java Virtual Machine memory allocation (under 'General').
%
% MANDATORY INPUTS:
%   - U: Raw phase displacement field. You must format your data to 6D:
%       -- Y, X, Z, T, Displacement Vectors, Frequencies
%   - freqs: vector of frequencies. If monofrequency acquisition, this is a
%     single number
%   - voxel Spacing: voxels spacing in METRES (for ex. [.002 .002 .005].
%     If voxels are isotropic, one number can be used for all; if voxels 
%     are anisotropic, use a 3 element vector in the order XYZ
%
% OPTIONAL INPUTS:
%   - invert_code: 0 for Gabor-weighted 3D (longest time), 1 for unweighted 3D (short time), 2 for unweighted with in-plane derivatives only(short time)
%	- bwVec: a custom vector for the Gabor weightings. Most common use is a short set like [3 5 7] to use the weighted inversion but save inversion time
%	- unwrap_code: 0 to use the built in unwrapper, >0 to skip
%	- dfw_code: >0 invokes the Divergence Free Wavelet by Frank Ong, but you need to have installed it. Default is 0.
%
% Typical example: [mag phi] = ESP(U, [30 35 40 45], .002, 2);
%
% The complex dual tree wavelets are courtesty of Ivan Selesnick at NYU.
% The dualtree wavelet code in this distribution comes from his software page at
% http://eeweb.poly.edu/iselesni/WaveletSoftware/ Please cite this paper when using: 
% I. W. Selesnick, R. G. Baraniuk, and N. C. Kingsbury, “The dual-tree complex 
% wavelet transform,” Signal Processing Magazine, IEEE, vol. 22, no. 6, pp. 123–151, 2005.
%
% If you use the OGS denoising please cite:
% P.-Y. Chen and I. W. Selesnick. 'Group-sparse signal denoising: 
% non-convex regularization, convex optimization.' IEEE Trans. on Signal Processing, 62(13):3464-3478
%
% If you use the Non-Negative Garotte Thresholding instead please cite:
% H. Gao. Wavelet shrinkage denoising using the nonnegative garrote. J. Comput. Graph. Statist., 7:469–488, 1998.
%
% I recommend the program Fiji (at fiji.sc) for visualisation over Matlab's inbuilt functions. 
% If you download Fiji and put it in your matlab path you can run ImageJ through Matlab by entering the
% command "Miji". You can then use the enclosed function "openImage" to open any result from ESP of any dimensions.

%% Load java archive. Alter this to your path if you have placed the folder differently

if(nargin == 1)
    unwrapped = 0;
end

%% normalise and unwrap
U = preproc(U);


%% Fourier transform
U = fft(U, [], 4);
snr = abs(U(:,:,:,2,:,:)) ./ sum(abs(U(:,:,:,3:end,:,:)), 4);
U = squeeze(U(:,:,:,2,:,:));
assignin('base', 'fft', U);

%% Z Denoise
%display('Z denoise');
%U = dt_den_1d(U);


end
