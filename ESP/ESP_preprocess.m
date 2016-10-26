function [ft, denoise, sm, hodge] = ESP_preprocess(U, freqs, voxelSpacing, speed, noUnwrap, DFW, lambda)
%%
% [mag phi] = ESP(U, freqs, voxelSpacing, super, speed, noUnwrap)
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
%   - super: super-resolution multiple, recommended 2x for 2-4 frequencies
%	and 4x for 5+ frequencies. default is 1x (i.e. no super resolution)
%   - speed: the following speed-quality tradeoffs are available. Default
%   is 0
%       speed = 0 best results. OGS denoising, weighted multiscale inversion
%       speed = 1 compromise. OGS denoising, unweighted inversion
%       speed = 2 fastest. NNG denoising, unweighted inversion
%   - noUnwrap: if data is already unwrapped, any value >0 for this arg
%     skips unwrap step
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
gb = tic;
display('ESP alpha 0.1 by Eric Barnhill (e.barnhill@sms.ed.ac.uk). Please do not share yet')
javaaddpath([pwd '/ESP.jar'])
% TODO make this part of an installer script 
U = double(U);
if (max(U(:)) - min(U(:)) > 2*pi)
display('normalizing');
U = javaMethod('normalizeOther', 'ESP.Utilities', U);
% if you are normalizing using the 0-4095 range of a DICOM, use this
% instead:
% U = javaMethod('normalizeFromDicom', 'ESP.Utilities', U);
end

% if single frequency or single displacement vector, duplicate things so Matlab doesn't
% remove singleton dimensions
twoD = 0;
singleComp = 0;
singleFreq = 0;
if (size(U,3) == 1)
    twoD = 1;
	U = cat(3, U, U, U);
end
if (size(U,5) == 1)
    singleComp = 1;
    U = cat(5, U, U, U);
end
if (size(U,6) == 1)
    singleFreq = 1;
    U = cat(6, U, U);
    freqs = cat(2, freqs, freqs);
end
szOrig = size(U);
% unwrap
if (nargin < 6)
    noUnwrap = 0;
end
tic
U6D = ESP.Unwrapper6D(4);
switch noUnwrap
    case 0
        display('Unwrapping...');
        U = javaMethod('unwrap', U6D, U);
    case 1
        display('Unwrapping no adaptive smooth...');
        U = javaMethod('unwrapNoSmooth', U6D, U);
    case 2
        display('Unwrapping no corrections...');
        U = javaMethod('unwrapNoCorrect', U6D, U);
    case 3
        display('skipping unwrap');
end
toc
if (nargin < 9)
    lambda = 0.06;
end
%% Fourier transform
U = fft(U, [], 4);
U = squeeze(U(:,:,:,2,:,:));
ft=U;

%% Get some parameters
sz = size(U);

pwr = 0;
while (2^pwr < max(sz)) 
    pwr = pwr+1;
end
xDim = max(2^pwr,64);

if (sz(3)*4) < xDim 
    index1 = sz(3)*3-2;
    index2 = sz(3)*4-3;
else
    index1 = sz(3);
    index2 = sz(3)*2-1;
end
% add padding for inversion
index1 = index1 - 5;
index2 = index2 + 4;

if size(voxelSpacing) == 1
    spacing = [voxelSpacing voxelSpacing voxelSpacing];
else
    spacing = voxelSpacing;
end

if (nargin < 5) 
    speed = 0;
end

%% denoise

Uex = zeros(xDim, xDim, xDim, sz(4), sz(5));
for n = 1:sz(5)
    for m = 1:sz(4)
        Uex(:,:,:,m,n) = extendZ(U(:,:,:,m,n), xDim);
    end
end
U = Uex;

if (DFW > 0) 
    tic
    display ('Hodge Decomposition...');
    UR1 = zeros(xDim, xDim, xDim, sz(5));
    UR2 = zeros(xDim, xDim, xDim, sz(5));
    UR3 = zeros(xDim, xDim, xDim, sz(5));
    UI1 = zeros(xDim, xDim, xDim, sz(5));
    UI2 = zeros(xDim, xDim, xDim, sz(5));
    UI3 = zeros(xDim, xDim, xDim, sz(5));
    for m = 1:sz(5)
      [UR1(:,:,:,m), UR2(:,:,:,m), UR3(:,:,:,m)] = dfwavelet_thresh_SURE_MAD(real(U(:,:,:,1,m)), real(U(:,:,:,2,m)), real(U(:,:,:,3,m)), [8 8 8], [1 1 1]);
      [UI1(:,:,:,m), UI2(:,:,:,m), UI3(:,:,:,m)] = dfwavelet_thresh_SURE_MAD(imag(U(:,:,:,1,m)), imag(U(:,:,:,2,m)), imag(U(:,:,:,3,m)), [8 8 8], [1 1 1]);
    end
    U = zeros(xDim, xDim, xDim, sz(5), 3);
    U(:,:,:,:,1) = UR1 + 1i*UI1;
    U(:,:,:,:,2) = UR2 + 1i*UI2;
    U(:,:,:,:,3) = UR3 + 1i*UI3;
    U = permute(U, [1 2 3 5 4]);
    toc 
end
hodge = U;
display('Denoising...');
tic
denR = zeros(xDim, xDim, xDim, sz(4), sz(5));
denI = zeros(xDim, xDim, xDim, sz(4), sz(5));
% frontside adjustments for singletons
denoiseSizes = sz;
if (twoD == 1)
    denoiseSizes(3) = 1;
end
if (singleComp == 1)
    denoiseSizes(4) = 1;
end
if (singleFreq == 1)
    denoiseSizes(5) = 1;
end
% denoise
for n = 1:denoiseSizes(5)
    display([num2str(freqs(n)), 'Hz']);
    for m = 1:denoiseSizes(4)
        if (twoD > 0)
            u = extendZ(U(:,:,:,m,n),128);
            denR(:,:,1,m,n) = DT_2D(real(u(:,:,1)));
            denI(:,:,1,m,n) = DT_2D(imag(u(:,:,1)));
            for k = 2:xDim
                denR(:,:,k,m,n) = denR(:,:,1,m,n);
                denI(:,:,k,m,n) = denI(:,:,1,m,n);
            end
        else
            if (speed == 2)
                display('soft denoise');
                denR(:,:,:,m,n) = DT_SOFT(real(U(:,:,:,m,n)));
                denI(:,:,:,m,n) = DT_SOFT(imag(U(:,:,:,m,n)));
            elseif (speed == 3)
                display('2d denoise');
                for k = 1:xDim
                    denR(:,:,k,m,n) = DT_2D(real(U(:,:,k,m,n)));
                    denI(:,:,k,m,n) = DT_2D(imag(U(:,:,k,m,n)));
                end
            elseif (speed == 4)
                display('no denoise');
                denR(:,:,:,m,n) = real(U(:,:,:,m,n));
                denI(:,:,:,m,n) = imag(U(:,:,:,m,n));
            else
                display('OGS denoise');
                denR(:,:,:,m,n) = DT_OGS(real(U(:,:,:,m,n)), lambda);
                denI(:,:,:,m,n) = DT_OGS(imag(U(:,:,:,m,n)), lambda);
            end
        end
    end
end
% backside adjustments for singletons
if (singleComp == 1)
    for m = 2:sz(4)
        denR(:,:,:,m,:) = denR(:,:,:,1,:);
        denI(:,:,:,m,:) = denI(:,:,:,1,:);
    end
end
if (singleFreq == 1)
    for n = 2:sz(4)
        denR(:,:,:,:,n) = denR(:,:,:,:,1);
        denI(:,:,:,:,n) = denI(:,:,:,:,1);
    end
end
U = denR + 1i*denI;
denoise = U;
toc
for n = 1:size(ft,5)
    for m = 1:size(ft,4)
        sm(:,:,:,m,n) = smooth3(ft(:,:,:,m,n), 'gaussian', [5 5 5], 1.3);
    end
end
display('Total processing time:');
toc(gb)

end






