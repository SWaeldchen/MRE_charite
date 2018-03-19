function [y] = gaussian_highpass(x, d0)

sz=size(x);
f_transform=fft2(x);
f_shift=fftshift(f_transform);
p=sz(1)/2;
q=sz(2)/2;

[i, j] = meshgrid(1:sz(2),1:sz(1));
distance=sqrt((i-p).^2+(j-q).^2);
low_filter=1-exp(-(distance).^2/(2*(d0^2)));
filt_rep = repmat(low_filter, [1 1 sz(3) sz(4) sz(5) sz(6)]);
filter_apply=f_shift.*filt_rep;
filtered=ifftshift(filter_apply);
y=ifft2(filtered);