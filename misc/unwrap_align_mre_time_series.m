function u = unwrap_align_mre_time_series(phase, mask, unwrap)

if nargin < 3
    unwrap = 0;
end

if unwrap
    % 2d phase unwrap of 6D time series
    u = dct_unwrap(phase, 2);
else
    u = phase;
end
% for bookkeeping
sz = size(u);
nslices = sz(3);
TIME_STEPS = 8;
% find correct shift
if numel(sz) < 6
    d6 = 1;
else
    d6 = sz(6);
end
for f = 1:d6
    for d = 1:3
        for z = 2:nslices
            prev_series = squeeze(u(:,:,z-1,:,d,f));% 2d phase unwrap of 6D time series
            curr_series = squeeze(u(:,:,z,:,d,f));
            curr_series = shift_time_steps(prev_series, curr_series, mask(:,:,z), TIME_STEPS);
            curr_series = fine_tune(prev_series, curr_series, mask(:,:,z), TIME_STEPS);
            u(:,:,z,:,d,f) = curr_series;
        end
    end
end

end

function curr_shift = shift_time_steps(prev_series, curr_series, mask, TIME_STEPS)
    phase_diffs = masked_phase_diff_ts(prev_series, curr_series, mask);
    [~, I] = min(abs(phase_diffs));
    % now shift the time steps through the volume for this slice
    curr_shift = shift_volume_time_steps(curr_series, I, TIME_STEPS);
end


function u_shifted = shift_volume_time_steps(u, I, TIME_STEPS)
    % shift volumes
    order_vector = [I:TIME_STEPS, 1:I-1];
    u_shifted = u(:,:,order_vector);
end

function curr_tune = fine_tune(prev_series, curr_series, mask, TIME_STEPS)
    BINS = 8;
    shifts = linspace(-2*pi/TIME_STEPS, 2*pi/TIME_STEPS, BINS);
    z = zeros(BINS, 1);
    prev_cplx = exp(1i*prev_series);
    mask_rep = repmat(mask, [1 1 TIME_STEPS]);
    for n = 1:BINS
        curr_series_shift = exp(1i.*(curr_series)).*exp(1i*shifts(n));
        diffs = angle(curr_series_shift ./ prev_cplx).*mask_rep; 
        z(n) = sqrt(mean(diffs(:).^2)); % RMSE
    end
    [~, I] = min(abs(z));
    curr_tune = dct_unwrap(angle(exp(1i.*curr_series).*exp(1i.*shifts(I))),2);
end