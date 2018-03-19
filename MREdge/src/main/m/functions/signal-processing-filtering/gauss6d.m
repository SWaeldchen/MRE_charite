function [smoothed] = gauss6d(image, sigma)

smoothed = zeros(size(image));
sz = ones(1,6);
sz(1:ndims(image)) = size(image);
for p = 1:sz(6)
    for n = 1:sz(5);
        for m = 1:sz(4);
            smoothed(:,:,:,m,n,p) = smooth3(image(:,:,:,m,n,p), 'gaussian', [5 5 5], sigma);
        end
    end
end
