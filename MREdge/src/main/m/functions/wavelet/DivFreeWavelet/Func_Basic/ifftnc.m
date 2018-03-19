function f = ifftnc(F)
% Centered fast Fourier Transform for 2D
    f = ifftshift(ifftn(fftshift(F)));
end