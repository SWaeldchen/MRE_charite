function F = fftnc(f)
% Centered fast Fourier Transform for 2D
    F = fftshift(fftn(ifftshift(f)));
end