function z = align_phases(source, target, mask)

if nargin < 3
    mask = ones(size(source));
end
mask(mask==0) = nan;

sz = size(source);
source = source(:);
target = target(:);

BINS = 512;
SHIFTS = linspace(-pi, pi, BINS);
% to avoid high memory demands, discard any previous solutions that were
% farther away

best = source;
lowest_error = Inf;
target_angle = exp(1i*angle(target));
for n = 1:BINS
    shifted = source.*exp(1i*SHIFTS(n));
    phase_differences = angle( exp(1i*angle(shifted) )./ target_angle);
    phase_differences = phase_differences.*mask(:);
    error= sqrt(mean(phase_differences(~isnan(phase_differences)).^2));
    if error < lowest_error
        lowest_error = error
        best = shifted;
    end
end

z = reshape(best, sz);
