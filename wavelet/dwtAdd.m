function [res] = dwtAdd(image1, image2);

% adds images in wavelet domain

for m = 1:2
    for n = 1:3
        display([num2str(m), ' ', num2str(n)]);
        size(d1{m}{n})
        d3{m}{n} = d1{m}{n} + d2{m}{n};
    end
end
    d3{3} = d1{3} + d2{3};
