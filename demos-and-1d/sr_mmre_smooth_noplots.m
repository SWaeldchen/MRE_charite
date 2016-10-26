function [l1 l2] = sr_mmre_smooth_noplots(spike_int, sr, interp_meth, base_k, T)
% Analytic simulation of MR Elastography
% super-resolution interface detection
%
% (c) Eric Barnhill 2016, BSD License.
%
% DESCRIPTION: 
%
% This simulation program is intended to enable the exploration of 
% MDEV-based super-resolution MR Elastography under realistic conditions.
%
% The simulation first generates a 1D collection of complex wave fields 
% across a narrow band of wavenumbers. The code assumes unit-length
% stiffness and unit wave amplitude on a unit-length grid. 
%
% To simulate within-tissue heterogeneities, the underlying 'stiffness' is 
% slowly varied across the image by adding white-noise shifts to the
% instaneous phase gradient at each sample.
%
% To simulate interfaces, delta spikes in phase are added to the slowly
% varying stiffness with either a spacing specified by the user, or
% randomly. The user can specify a specific number of spikes, 0 for random
% spikes, or -1 for no spikes.
%
% Uses can also vary the base wavelength, method of interpolation
% (linear or wavelet) and Super Res level.
%
% Please note that this is _not_ intended as a best-case demo software
% but rather allows interested researchers to explore the range, potential
% and limitations of MDEV based Super Res-MMRE. Spikes far apart will be properly
% resolved by all methods and spikes close together, or very high levels
% Super Res, will be aliased by all methods. In between these extremes the 
% super-resolution will be apparent.
%
% USAGE:
%
% sr_mmre_sim(spike_int, sr, interp_meth, base_k)
%
% INPUTS:
%
% spike_int: Distance between spikes. 
% Set the spacing between delta spikes, 0 for random spikes, or -1 for 
% no spikes. The smaller the spacing, the more the aliasing.
%
% sr: Level of super-resolution. At present this must be an 
% integer to facilitate interpolation.
%
% interp_meth: Choice of interpolation method. User can choose from 
% 1 (linear) or 2 (dual-tree wavelet).
%
% base_k: Wavenumber of lowest base frequency across the 128 tap sample.
% When set too high, downsampled waves will be lost. When set too low,
% the Laplacian falls very close to zero and the simulation becomes
% numerically unstable.
% Default: 4
%
%% Set defaults if necessary
if (nargin < 5)
	T = 0.1;
	if (nargin < 4)
		base_k = 2;
		if (nargin < 3) 
		    interp_meth = 1;
		    if (nargin < 2)
		        sr = 4;
		        if (nargin < 1)
		            spike_int = 0;
		        end
		    end
		end
	end
end
%% Validate arguments
if sr ~= round(sr)
    display('Error. Super factor must be integer.');
    return
end
%{
if base_k > 8
    display('Error. Base k must be under 8. Higher values will alias the shear wave in the downsampling.');
    return
end
%}
if base_k < 1
    display('Error. Base k must be at least 1 for numerical stability.');
    return
end
if spike_int > 127
    display('Error. Spike interval must be within 128 tap simulation size.');
    return
end

%% Some constants. These can be edited but may not produce a stable result

gauss_sigma = .01;
spike_phase_shift = base_k*pi/2;
%spike_phase_shift = pi;
spike_randn_cutoff = 2;
bandwidth_coeffs = {1,1.1,1.2,1.3};
laplacian = [1; -2; 1];
disrupted_r = 1;

%% Generate elasticity fields

% Generate base waves
x = repmat({zeros(128,1)}, [numel(bandwidth_coeffs) 1]);
increment = cell(numel(bandwidth_coeffs), 1);
base_wavelength = 128/(base_k);
for n = 1:numel(bandwidth_coeffs)
    increment{n} = 2*pi / (base_wavelength) * bandwidth_coeffs{n};
end
% Add slow variation and spikes
first_spike = 0;
for n = 2:128;
    h = 1; % to set h scope
    r = 1;
    if spike_int >= 0 % negative numbers produce no spikes
        if spike_int == 0  % case random spikes
            if abs(randn(1)) > spike_randn_cutoff % if random spike
                h = spike_phase_shift;
                r = disrupted_r;
                if first_spike == 0 && n > 20
                    first_spike = n;
                end
            else % if no random spike
                 h = (1 - gauss_sigma) + gauss_sigma*randn; 
            end
        elseif mod(n, spike_int) == 0 % case specified spike intervals
           h = spike_phase_shift;
           r = disrupted_r;
        else % if no spike at this point, stochastically vary
       h = (1 - gauss_sigma) + gauss_sigma*randn; 
        end
    else % if no spikes at all, stochastically vary
       h = (1 - gauss_sigma) + gauss_sigma*randn; 
    end
    for p = 1:numel(x) % now shift the phase 
        prev = x{p}(n-1);
        [t, ~] = cart2pol(real(prev), imag(prev));
        [a, b] = pol2cart(t+increment{p}*h, r);
        x{p}(n) = a + 1i*b;
    end
end

assignin('base', 'x1', x{1})
%% Set some display parameters

% Downsampling plus deriatives will create substantial
% boundary conditions when upsampled. Eliminate for better comparison.
ind1 = 6*sr; 
ind2 = 128-ind1;
% Params for focus on spike.
ind1_d = round(ind1/sr) ;
ind2_d = round(ind2/sr) +1;
if spike_int > 0
    ind1_f = round(ind2/2);
    ind2_f = ind1_f + 2*spike_int;
    ind1_d_f = round(ind2/(2*sr));
    ind2_d_f = ind1_d_f + 2*spike_int/sr;
elseif first_spike > 0;
    ind1_f = first_spike - 16;
    ind2_f = first_spike + 16;
    ind1_d_f = round(ind1_f/sr);
    ind2_d_f = round(ind2_f/sr);
else
    ind1_f = round(ind2/2);
    ind2_f = ind1_f + 16;
    ind1_d_f = round(ind2/(2*sr));
    ind2_d_f = ind1_d_f + 32/sr;
end
x_ds = cell(numel(x),1);

%% Downsample
% Throw out voxels, creating aliased data
for n = 1:numel(x)
    x_ds{n} = x{n}(1:sr:end);
end

assignin('base', 'xds1', x_ds{1})

%% get SR

x_sr = cell(numel(x), 1);
guides = cell(numel(x), 1);

assignin('base', 'guides', guides);

%% Take derivatives
x_lap = cell(numel(x), 1);
x_ds_lap = cell(numel(x), 1);
x_sr_pre_lap = cell(numel(x), 1);
x_sr_post_lap = cell(numel(x), 1);
for n = 1:numel(x)
    x_lap{n} =lap(x{n});
    x_ds_lap{n} = lap(x_ds{n})/sr.^2;
    x_sr{n} = spline_interp(x_ds{n}, sr);
    x_sr_pre_lap{n} = lap(x_sr{n}); 
	x_sr_post_lap{n} = spline_interp(x_ds_lap{n}, sr); 
end

%% Interpolate Downsampled Displacements

%% Inversion Numerator and Denominator
x_orig_num = [];
x_orig_denom = [];
x_ds_num = [];
x_ds_denom = [];
x_sr_pre_num = [];
x_sr_pre_denom = [];
x_sr_post_num = [];
x_sr_post_denom = [];
x_gt_comps = [];


for n = 1:numel(x)
    x_gt_comps = cat(2, x_gt_comps, 10*bandwidth_coeffs{n} ./ gradient(unwrap(angle(x{n}))) );
    x_orig_num = cat(2, x_orig_num, bandwidth_coeffs{n}.^2 * abs(x{n}));
    x_orig_denom = cat(2, x_orig_denom, abs(x_lap{n}));
    x_ds_num = cat(2, x_ds_num, bandwidth_coeffs{n}.^2 *abs(x_ds{n}));
    x_ds_denom = cat(2, x_ds_denom, abs(x_ds_lap{n}));
    x_sr_pre_num = cat(2, x_sr_pre_num, bandwidth_coeffs{n}.^2 * abs(x_sr{n}));
    x_sr_pre_denom = cat(2, x_sr_pre_denom, abs(x_sr_pre_lap{n}));
    x_sr_post_num = cat(2, x_sr_post_num, bandwidth_coeffs{n}.^2 * abs(x_sr{n}));
    x_sr_post_denom = cat(2, x_sr_post_denom, abs(x_sr_post_lap{n}));
end

%% Inversion Divide

x_gt = sum(x_gt_comps, 2) / numel(x);

inv_comps_orig = x_orig_num ./ x_orig_denom;
inv_orig = sum(x_orig_num, 2) ./ sum(x_orig_denom, 2);

inv_comps_down = x_ds_num ./ x_ds_denom;
inv_down = sum(x_ds_num, 2) ./ sum(x_ds_denom, 2);

inv_comps_naive = spline_interp(inv_comps_down, sr);
inv_naive = spline_interp(inv_down, sr);

inv_comps_sr_pre = x_sr_pre_num ./ x_sr_pre_denom;
inv_sr_pre = sum(x_sr_pre_num, 2) ./ sum(x_sr_pre_denom, 2);
inv_sr_pre(isinf(inv_sr_pre)) = 0;

inv_comps_sr_post = x_sr_post_num./ x_sr_post_denom;
inv_sr_post = sum(x_sr_post_num, 2) ./ sum(x_sr_post_denom, 2);

comps = {x_gt_comps, inv_comps_orig, inv_comps_down, inv_comps_naive, inv_comps_sr_pre, inv_comps_sr_post};
inversions = {x_gt, inv_orig, inv_down, inv_naive, inv_sr_pre, inv_sr_post};

assignin('base', 'x_ds', x_ds);
assignin('base', 'x_orig', x);

l1_or = sum(abs(inv_orig - x_gt));
l1_naive = sum(abs(inv_naive - x_gt));
l1_sr_pre = sum(abs(inv_sr_pre - x_gt));
l1_sr_post = sum(abs(inv_sr_post - x_gt));
l2_or = sum((inv_orig - x_gt).^2);
l2_naive = sum((inv_naive - x_gt).^2);
l2_sr_pre = sum((inv_sr_pre - x_gt).^2);
l2_sr_post = sum((inv_sr_post - x_gt).^2);
l1 = [l1_or l1_naive l1_sr_post];
l2 = [l2_or l2_naive l2_sr_post];
assignin('base','inv_sr_pre', inv_sr_pre);
assignin('base','inv_sr_post', inv_sr_post);
assignin('base','x_gt', x_gt);
