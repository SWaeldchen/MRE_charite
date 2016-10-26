function [smoothedVals] = smoothPlotHisto(bins, vals, sigma)

length = size(vals,1);
vec = 1:length;
filt = exp(-vec.^2 ./ sigma.^2)';
histoDCT = dct(vals);
histoDCT = histoDCT .* filt;
smoothedVals = idct(histoDCT);
figure;
hold on;
plot(bins, vals); plot(bins, smoothedVals, 'red', 'lineWidth', 3);
