function [resh] = open_fourier_image(image, mij_instance, name, log_)
if (nargin < 4)
    log_ = 1;
    if (nargin < 3)
        name = inputname(1);
    end
end
sz = size(image);
thirdDim = 1;
for n = 1: (numel(sz)-2);
    thirdDim = thirdDim * sz(n+2);
end
resh = reshape(image, sz(1), sz(2), thirdDim);
resh = double(resh);
for n = 1:thirdDim
    if (log_ == 1)
        resh(:,:,n) = log(normalizeImage(abs(fftshift(fft2(resh(:,:,n))))));
    else
        resh(:,:,n) = normalizeImage(abs(fftshift(fft2(resh(:,:,n)))));
    end
end
mij_instance.createImage(name, resh, 1);
