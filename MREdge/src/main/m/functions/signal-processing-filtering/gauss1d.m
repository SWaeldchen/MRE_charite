function [ y ] = gauss1d( length, sigma )

if (mod(length,2) ~= 0)
    length = length+1;
end
mid = length / 2;
x = [-mid:1:mid];
y = exp( -(x.^2) ./ (sigma^2) );
end

