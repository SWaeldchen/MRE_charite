function [SNR, SNR_DB] = imageSNR(image)

sortIm = sort(image(:));
interquart = sortIm(round(numel(sortIm))*0.25: round(numel(sortIm*0.75)));
range = max(interquart(:)) - min(interquart(:));
istd = std(interquart(:));
SNR = range./istd;
SNR_DB = 20*log10(SNR);