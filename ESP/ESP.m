function [mag, phi, snr] = ESP(U, freqvec, spacing, denoise_meth, super_factor, unwrap, twoD, den_fac, hodge_code, hodge_iter)

% ESP v0.51g (c) 2016 Eric Barnhill. 

% USAGE:

% [mag, phi, snr] = ESP(U, freqvec, spacing, denoise_meth, super_factor, unwrap)

% INPUTS:

% U: 6D wave field
%
% freqvec: vector of driving frequencies (Hz) in the experiment
%
% spacing: pixel spacing [X Y Z]
%
% denoise_meth: 0 for full 3D (only recommended for certain data sets)
% 				1 for z then xy (recommended for most sets incl. Edinburgh)
%
% super_factor: interpolation factor for super-resolution. most frequent number is 4.
%				set to zero, will auto-calculate a best guess.
%
% OUTPUTS:
%
% Mag: Shear modulus magnitude map |G*|
% Phi: Phase angle Phi
% SNR: The wave-to-noise SNR ratio. Good for evaluating image quality.
%

	% get organised and set some values
   if nargin < 7
       twoD = 0;
      if nargin > 6
           unwrap = 0;
           if nargin < 5
                super_factor = 0;
           end
      end
   end


	if super_factor == 0
		disp('auto select sr')
        avg_freqs = mean(freqvec);
        min_freqs = min(freqvec);
        super_factor = (avg_freqs / min_freqs)^2;
	end
    all = tic;
	U = double(U);
	mn = min(U(:));
	mx = max(U(:));
	if (mx - mn) > 2*pi
		U = (U-mn) ./ (mx-mn) *2*pi;
	end

    if numel(spacing) == 1
        spacing = [spacing spacing spacing];
    end

    % unwrap, temporal fourier transform - deprecated

    if unwrap > 0
        display('Unwrapping');
        U = dct_unwrap(U);
    end
        U_ft = fft(U, [], 4);
        U_noise = squeeze(sum(abs(U_ft(:,:,:,3:end,:,:)), 4));
        U = squeeze(U_ft(:,:,:,2,:,:));
        snr = abs(U) ./ U_noise;
    

	if (ndims(U) == 4)
		d5 = 1;
	else
		d5 = size(U,5);
    end


  % denoise

    parfor m = 1:d5
		if denoise_meth == 0
			display('Denoising z-3D')
     		U(:,:,:,:,m) = dtdenoise_3d_mad(U(:,:,:,:,m), den_fac);
		elseif denoise_meth == 1
 			display('Denoising z-xy')
			U(:,:,:,:,m) = dtdenoise_z_auto_noise_est(U(:,:,:,:,m), 1);
	       	U(:,:,:,:,m) = dtdenoise_xy_pca_mad(U(:,:,:,:,m), 0.001, 3);
		end
    end
        assignin('base', 'U_denoise', U);

	% U = hodge_decomp(U, hodge_code, hodge_iter);
    
    assignin('base', 'U_hipass', U);

    % take derivatives and interpolate
  
	[magNum, magDenom, phiNum, phiDenom] = invert(U, freqvec, spacing, twoD);
    mag = magNum ./ magDenom;
    phi = acos(-phiNum ./ phiDenom);
	
    mag(isnan(mag)) = 0;
	phi(isnan(phi)) = 0;
    toc(all)
end
