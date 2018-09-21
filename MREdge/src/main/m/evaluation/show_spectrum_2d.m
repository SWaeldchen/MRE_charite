function [] = show_spectrum_2d(u)
%SHOW_SPECTRUM_2D Summary of this function goes here
%   Detailed explanation goes here

u_fft = fftshift(fft(fft(u, [],1),[],2));

imagesc(abs(u_fft));


end

