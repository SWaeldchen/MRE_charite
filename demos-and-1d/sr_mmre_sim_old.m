function sr_mmre_sim(spike_int, sr, interp_meth, base_k)
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
% sr: Level of super-resolution. At present this must be a power of 2
% in order to properly used the wavelet-based Super Res.
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
%% Validate arguments
if (log(sr) / log(2)) - round(log(sr)/log(2)) ~= 0
    display('Error. Super factor must be power of 2');
    return
end
%if base_k > 8
%    display('Error. Base wavelength must be under 8. Higher values will alias the shear wave in the downsampling.');
%    return
%end
if base_k < 0.1
    display('Error. Base wavelength must be at least 0.1 for numerical stability.');
    return
end
if spike_int > 127
    display('Error. Spike interval must be within 128 tap simulation size.');
    return
end
if (log(spike_int) / log(2)) - round(log(spike_int) / log(2)) == 0
    display('Warning. When spike_int is exactly a power of two, the Scan Res');
    display(' results may perform poorly. However Super Res will be fine.');
end
%% Some constants. These can be edited but may not produce a stable result

gauss_sigma = 0.02;
%spike_phase_shift = base_k*pi/32;
spike_phase_shift = pi;
spike_randn_cutoff = 1.6;
bandwidth_coeffs = {1, 1.1, 1.2, 1.3, 1.4, 1.5};
laplacian = [1; -2; 1];
figuretally = 0;

%% Generate elasticity fields

% Generate base waves
x = repmat({zeros(128,1)}, [6 1]);
increment = cell(numel(bandwidth_coeffs), 1);
base_wavelength = 128/(base_k);
for n = 1:6
    increment{n} = 2*pi / (base_wavelength) * bandwidth_coeffs{n};
end
% Add slow variation and spikes
first_spike = 0;
for n = 2:128;
    h = 1; % to set h scope
    if spike_int >= 0 % negative numbers produce no spikes
        if spike_int == 0  % case random spikes
            if abs(randn(1)) > spike_randn_cutoff % if random spike
                h = randn*spike_phase_shift;
                if first_spike == 0 && n > 20
                    first_spike = n;
                end
            else % if no random spike
                 h = (1 - gauss_sigma) + gauss_sigma*randn; 
            end
        elseif mod(n, spike_int) == 0 % case specified spike intervals
           h = spike_phase_shift;
        else % if no spike at this point, stochastically vary
       h = (1 - gauss_sigma) + gauss_sigma*randn; 
        end
    else % if no spikes at all, stochastically vary
       h = (1 - gauss_sigma) + gauss_sigma*randn; 
    end
    for p = 1:numel(x) % now shift the phase 
        prev = x{p}(n-1);
        [t, r] = cart2pol(real(prev), imag(prev));
        r = (1-r/2); % regain magnitude after disruption
        [a, b] = pol2cart(t+increment{p}*h, r);
        x{p}(n) = a + 1i*b;
    end
end

%% Set some display parameters

% Downsampling plus deriatives will create substantial
% boundary conditions when upsampled. Eliminate for better comparison.
ind1 = 6*sr; 
ind2 = 128-ind1;
% Params for focus on spike.
ind1_d = round(ind1/sr);
ind2_d = round(ind2/sr);
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
x_down = cell(numel(x),1);

%% Downsample
% Throw out voxels, creating aliased data
for n = 1:numel(x)
    x_down{n} = x{n}(1:sr:end);
end
figuretally = figuretally + 1;
figure(figuretally);
set(gcf, 'Color', 'w');
for n = 1 % top row has titles
    subplot(numel(x), 4, (n-1)*4+1); complexPlot(x{n}); xlim([ind1 ind2]); title('Complex Wavefield, Ground Truth');
    subplot(numel(x), 4, (n-1)*4+2); complexPlot(x_down{n}); xlim([ind1_d ind2_d]); title('Complex Wavefield, Scan Res');
    subplot(numel(x), 4, (n-1)*4+3); complexPlot(x{n}); xlim([ind1_f ind2_f]); title('Spike Focus, Ground Truth');
    subplot(numel(x), 4, (n-1)*4+4); complexPlot(x_down{n}); xlim([ind1_d_f ind2_d_f]); title('Spike Focus, Scan Res');
end
for n = 2:numel(x)
    subplot(numel(x), 4, (n-1)*4+1); complexPlot(x{n}); xlim([ind1 ind2]);
    subplot(numel(x), 4, (n-1)*4+2); complexPlot(x_down{n}); xlim([ind1_d ind2_d]);
    subplot(numel(x), 4, (n-1)*4+3); complexPlot(x{n}); xlim([ind1_f ind2_f]);
    subplot(numel(x), 4, (n-1)*4+4); complexPlot(x_down{n}); xlim([ind1_d_f ind2_d_f]);
end

%% Take derivatives
x_lap = cell(numel(x), 1);
x_down_lap = cell(numel(x), 1);
x_rs_lap = cell(numel(x), 1);
for n = 1:numel(x)
    x_lap{n} = convn(x{n}, laplacian, 'same');
    x_down_lap{n} = convn(x_down{n}, laplacian / (sr.^2) , 'same');
    x_rs_lap{n} = convn(polar_interp(x_down{n}, sr, interp_meth), laplacian, 'same'); 
end
%{
figuretally = figuretally + 1;
figure(figuretally);
set(gcf, 'Color', 'w');
for n = 1 % top row has titles
    subplot(numel(x), 3, (n-1)*3+1); complexPlot(x_lap{n}); xlim([ind1 ind2]); title('Complex Laplacian Field, Ground Truth');
    subplot(numel(x), 3, (n-1)*3+2); complexPlot(x_down_lap{n}); xlim([ind1_d ind2_d]); title('Complex Laplacian Field, Scan Res');
    subplot(numel(x), 3, (n-1)*3+3); complexPlot(x_rs_lap{n}); xlim([ind1 ind2]); title('Complex Laplacian Field, Interpolated');
end
for n = 2:numel(x)
    subplot(numel(x), 3, (n-1)*3+1); complexPlot(x_lap{n}); xlim([ind1 ind2]);
    subplot(numel(x), 3, (n-1)*3+2); complexPlot(x_down_lap{n}); xlim([ind1_d ind2_d]);
    subplot(numel(x), 3, (n-1)*3+3); complexPlot(x_rs_lap{n}); xlim([ind1 ind2]);
end
%}
figuretally = figuretally + 1;
figure(figuretally);
set(gcf, 'Color', 'w');
for n = 1 % top row has titles
    subplot(numel(x), 3, (n-1)*3+1); complexPlot(x_lap{n}); xlim([ind1_f ind2_f]); title('Spike Focus, Ground Truth');
    subplot(numel(x), 3, (n-1)*3+2); complexPlot(x_down_lap{n}); xlim([ind1_d_f ind2_d_f]); title('Spike Focus, Scan Res');
    subplot(numel(x), 3, (n-1)*3+3); complexPlot(x_rs_lap{n}); xlim([ind1_f ind2_f]); title('Spike Focus, Interpolated');
end
for n = 2:numel(x)
    subplot(numel(x), 3, (n-1)*3+1); complexPlot(x_lap{n}); xlim([ind1_f ind2_f]);
    subplot(numel(x), 3, (n-1)*3+2); complexPlot(x_down_lap{n}); xlim([ind1_d_f ind2_d_f]);xlim([ind1_d_f ind2_d_f]);
    subplot(numel(x), 3, (n-1)*3+3); complexPlot(x_rs_lap{n}); xlim([ind1_f ind2_f]);
end

%% Interpolate
abs_naives_polar = cell(numel(x), 1);
abs_naive_laps_polar = cell(numel(x), 1);

for n = 1:numel(x)
    abs_naives_polar{n} = abs(polar_interp(x_down{n}, sr, interp_meth));
    abs_naive_laps_polar{n} = abs(convn(polar_interp(x_down{n}, sr, interp_meth), laplacian, 'same'));
end

%% Invert
x_orig_num = [];
x_orig_denom = [];
x_down_num = [];
x_down_denom = [];
x_super_num = [];
x_super_denom = [];
for n = 1:numel(x)
    x_orig_num = cat(2, x_orig_num, bandwidth_coeffs{n}.^2 * abs(x{n}));
    x_orig_denom = cat(2, x_orig_denom, abs(x_lap{n}));
    x_down_num = cat(2, x_down_num, bandwidth_coeffs{n}.^2 *abs(x_down{n}));
    x_down_denom = cat(2, x_down_denom, abs(x_down_lap{n}));
    x_super_num = cat(2, x_super_num, bandwidth_coeffs{n}.^2 * abs_naives_polar{n});
    x_super_denom = cat(2, x_super_denom, abs_naive_laps_polar{n});
end

inv_comps_orig = x_orig_num ./ x_orig_denom;
inv_orig = sum(x_orig_num, 2) ./ sum(x_orig_denom, 2);
inv_comps_down = x_down_num ./ x_down_denom;
inv_down = sum(x_down_num, 2) ./ sum(x_down_denom, 2);
inv_comps_naive = linear_interp(inv_comps_down, sr);
inv_naive = linear_interp(inv_down, sr);
inv_comps_super = x_super_num ./ x_super_denom;
inv_super = sum(x_super_num, 2) ./ sum(x_super_denom, 2);

if spike_int >= 0
    el_min = min(min(inv_comps_orig(20:end-20,:)))*0.75;
    el_max = max(max(inv_comps_orig(20:end-20,:)))*2;
    elastogram_ylims = [ el_min el_max ];
else
    mn = median(inv_super(~isnan(inv_super)));
    elastogram_ylims = [mn-5*sr mn+5*sr];
end

% isolate spikes and set to zero
med = median(inv_super(find(~isnan(inv_super))));
super_cut = med*1.5;

% add neighbours and clamp
spikes_comps_2 = find(inv_comps_super > super_cut);
spikes_comps_1 = spikes_comps_2 - 1;
spikes_comps_3 = spikes_comps_2 + 1;

spikes_fused_2 = find(inv_super > super_cut);
spikes_fused_1 = spikes_fused_2 - 1;
spikes_fused_3 = spikes_fused_2 + 1;

%spikes_comps = union(union(spikes_comps_1, spikes_comps_2), spikes_comps_3);
%spikes_fused = union(union(spikes_fused_1, spikes_fused_2), spikes_fused_3);
spikes_comps = spikes_comps_2;
spikes_fused = spikes_fused_2;
%inv_comps_super(spikes_comps) = super_cut - inv_comps_super(spikes_comps);
%inv_super(spikes_fused) = super_cut - inv_super(spikes_fused);
%inv_comps_super(spikes_comps) = med + log(inv_comps_super(spikes_comps) - med);
%inv_super(spikes_fused) = med + log(inv_super(spikes_fused) - med);

super_comps_medianfilt = medfilt3(inv_comps_super, [sr+1 1 1]);
super_fused_medianfilt = medfilt3(inv_super, [sr+1 1 1]);
inv_comps_super(spikes_comps) = super_comps_medianfilt(spikes_comps);
inv_super(spikes_fused) = super_fused_medianfilt(spikes_fused);

comps = {inv_comps_orig, inv_comps_down, inv_comps_naive, inv_comps_super};
inversions = {inv_orig, inv_down, inv_naive, inv_super};

%% Display elastograms

figuretally = figuretally + 1;
figure(figuretally);
set(gcf, 'Color', 'w');
for n = 1:numel(inversions)
    subplot(numel(inversions), 2, (n-1)*2+1); plot(comps{n}); 
    ylim([elastogram_ylims(1), elastogram_ylims(2)]);
    if (n ~= 2) 
        xlim([ind1 ind2]);
    else 
        xlim([ind1_d ind2_d]);
    end
    switch n
        case 1
            title('Ground Truth Elastogram, By Frequency');
        case 2
            title('Scan Res Elastogram, Downsampled, By Frequency');
        case 3
            title('Scan Res Elastogram, Upsampled, By Frequency');
        case 4
            title('Super Res Elastogram, By Frequency');
    end
    subplot(numel(inversions), 2, (n-1)*2+2); plot(inversions{n});
    ylim([elastogram_ylims(1), elastogram_ylims(2)]);
    if (n ~= 2) 
        xlim([ind1 ind2]);
    else 
        xlim([ind1_d ind2_d]);
    end
    switch n
        case 1
            title('Ground Truth Elastogram, Frequency Fused');
        case 2
            title('Scan Res Elastogram, Downsampled, Fused');
        case 3
            title('Scan Res Elastogram, Upsampled, Fused');
        case 4
            title('Super Res Elastogram, Fused');
    end
end

%sr_fig2;
%sr_fig3;
%sr_fig4;
nothing = 0; % for working within the sim
