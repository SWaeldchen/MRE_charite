function z = masked_phase_diff(prev_series, curr_series, mask)
sz = size(prev_series);
if numel(sz) ~= 3
    disp('masked_phase_diff ERROR: 3d only');
    return
end
n_slcs = sz(3);
mask_rep = repmat(mask, [1 1 n_slcs]);
prev_cplx = exp(1i*prev_series); % SAME MASK FOR ALL TIME STEPS
curr_cplx = exp(1i*curr_series);
z = zeros(n_slcs,1);
for n = 0:n_slcs-1
    curr_cplx_n = circshift(curr_cplx, [0 0 -n]); % so when n is 2, 2nd slice is first
    diffs = angle(curr_cplx_n ./ prev_cplx).*mask_rep; 
    z(n+1) = sqrt(mean(diffs(:).^2)); % RMSE
end