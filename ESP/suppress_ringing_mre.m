function [im_dering, masked_pwrspec] = suppress_ringing_mre(im)

sz = size(im);
cut = -4;
thresh = 0.2;

[x, y, z] = meshgrid( (1/sz(2):1/sz(2):1) - 0.5, (1/sz(1):1/sz(1):1) - 0.5, (1/sz(3):1/sz(3):1) - 0.5);
radius = sqrt(x.^2 + y.^2 + z.^2);

pwrspec_mask = normlogpwrspec(im);
spikes = zeros(size(im));
const = 1.5;
spikes(pwrspec_mask > cut*const*radius.^(0.3)) = 1;
spikes(radius < thresh) = 0;

im_dering = fftshift(fftn(im));

im_dering( spikes == 1) = 0;
suppressed_count = numel(im_dering(im_dering == 0));
suppressed_pct =  suppressed_count / numel(im_dering);

im_dering = ifftn(ifftshift(im_dering));

masked_pwrspec = pwrspec_mask;
masked_pwrspec(spikes == 1) = nan;

display(['Suppressed ', num2str(suppressed_count), ' of ', num2str(numel(im_dering)), ' or ' num2str(suppressed_pct*100), '%']);

                
