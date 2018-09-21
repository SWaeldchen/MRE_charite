function [M] = flip_for_fft(M, dir)
%FLIP_FOR_FFT Summary of this function goes here
%   Detailed explanation goes here

shape = size(M);

rowMiddle = ceil(shape(1)/2);
colMiddle = ceil(shape(2)/2);

if strcmp(dir, "back")
    M = [M(rowMiddle+1:end, :); M(1:rowMiddle, :)];
    M = [M(:, colMiddle+1:end), M(:, 1:colMiddle)];
elseif strcmp(dir, "for")
    M = [M(rowMiddle:end, :); M(1:rowMiddle-1, :)];
    M = [M(:, colMiddle:end), M(:, 1:colMiddle-1)];
end
    
    
end

