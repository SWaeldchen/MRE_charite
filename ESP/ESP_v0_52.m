function [mag, phi, snr] = ESP_v0_52(U, freqvec, spacing, super_factor, unwrap, denoise_strat)

% ESP alpha v0.5 (c) 2016 Eric Barnhill. 

% USAGE:

% function [mag, phi, snr] = ESP_v0_52(U, freqvec, spacing, super_factor, unwrap, denoise_strat, wavelet_curl, wavelet_lap)
% INPUTS:

% U: 6D wave field
%
% freqs: vector of driving frequencies (Hz) in the experiment
%
% spacing: pixel spacing [X Y Z]
%
% super_factor: interpolation factor for super-resolution. most frequent number is 4.
%
% twoD: flag for twoD Laplacian. This is the best idea when you only have a few
% slices (e.g. < 10) and therefore not much frequency information on the Z
% axis. It is much stabler in those cases. 0 = off (3D), 1 = on(2D)
% 
% z_group_size: denoising along the z axis is a delicate problem and you may need to alter this if you have multiple, % diverse phase events (like two different organs, or an organ and air) along the z. If the elastogram seems to shift % a bit suddenly from one slice to the next at one point in the image, reducing this to 3 or 5 might help.
%
% OUTPUTS:
%
% Mag: Shear modulus magnitude map |G*|
% Phi: Phase angle Phi
% SNR: The wave-to-noise SNR ratio. Good for evaluating image quality.
%

	% get organised and set some values
	key_args = 3;
	if nargin < key_args + 5
		wavelet_lap = 0;
		if nargin < key_args + 4
			wavelet_curl = 2;
			if nargin < key_args + 3
				denoise_strat = 0;
				if nargin < key_args+2
					unwrap = 0;
					if nargin < key_args+1 || super_factor == 0
						display('auto select sr')
						avg_freqs = mean(freqvec);
						min_freqs = min(freqvec);
						super_factor = (avg_freqs / min_freqs)^2;
					end
				end
			end
		end
	end
	if super_factor == 0
		display('auto select sr')
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
        U_ft = fft(U, [], 4);
        U_noise = squeeze(sum(abs(U_ft(:,:,:,3:end,:,:)), 4));
        U = squeeze(U_ft(:,:,:,2,:,:));
        snr = abs(U) ./ U_noise;
    end

	if (ndims(U) == 4)
		d5 = 1;
	else
		d5 = size(U,5);
    end


  % denoise
  
    parfor m = 1:d5
		if denoise_strat == 0
			display('Denoising z-3D')
     		U(:,:,:,:,m) = DT_3D_v0_51b(U(:,:,:,:,m)); % check if still the same
		else
 			display('Denoising z-xy')
			U(:,:,:,:,m) = dtdenoise_z_auto_noise_est(U(:,:,:,:,m));
	       	U(:,:,:,:,m) = dtdenoise_xy_pca(U(:,:,:,:,m));
		end
    end
        assignin('base', 'U_denoise', U);

      
    if unwrap == 0
		U = hodge_decomp(U, 2);
	end
    

    
    % take derivatives and interpolate

    twoD = 0;
 	U_lap = get_compact_laplacian(U, spacing, twoD);
	assignin('base', 'U_lap', U_lap);
  
	[magNum, magDenom, phiNum, phiDenom] = invert(U, U_lap, freqvec, super_factor);
    mag = magNum ./ magDenom;
    phi = acos(-phiNum ./ phiDenom);
	%{
	if super_factor > 1
		mag = ortho_ring_reduce(mag, super_factor);
		phi = ortho_ring_reduce(phi, super_factor);
	end
	%}
    mag(isnan(mag)) = 0;
	phi(isnan(phi)) = 0;
   toc(all)
end