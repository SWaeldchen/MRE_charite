function [r] = wlet_denoise(x, N, wName, bottom, thresh, stopLevel)
%WLET_DENOISE Summary of this function goes here
%   Detailed explanation goes here

[wx, L] = wavedec(x, N, wName);

wr = wthresh(wx, 'h', thresh*max(abs(wx)));

stop = 0;

wrLen = length(wr);
cutOff = floor(bottom*wrLen);

[wrSort, I] = sort(wr, 'ComparisonMethod', 'abs');
wrSort(1:cutOff) = 0;

wr(I) = wrSort;

for level=1:stopLevel
    stop = stop + L(end-level);
    
end

wr(end-stop+1:end) = 0;

r = waverec(wr, L, wName);

end

