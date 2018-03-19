function z = align_phases_topslc(source, target, mask)

if nargin < 3
    mask = ones(size(source));
end
mask(mask==0) = nan;

sz = size(source);
source_top = vec(source(:,:,1));
target_top = vec(target(:,:,1));

BINS = 512;
SHIFTS = linspace(-pi, pi, BINS);
% to avoid high memory demands, discard any previous solutions that were
% farther away

best = source;
lowest_error = Inf;
target_angle = exp(1i*angle(target_top));
for n = 1:BINS
    shifted = source_top.*exp(1i*SHIFTS(n));
    phase_differences = angle( exp(1i*angle(shifted) )./ target_angle);
    error= sqrt(mean(phase_differences(~isnan(phase_differences)).^2));
    if error < lowest_error
        lowest_error = error;
        best = source.*exp(1i*SHIFTS(n));
    end
end

z = reshape(best, sz);
