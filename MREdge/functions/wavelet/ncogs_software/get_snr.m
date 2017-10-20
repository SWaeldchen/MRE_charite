function SNR = get_snr(x, y)
% SNR = get_snr(x, y)
% Signal to noise ratio
%
% INPUT
%    x: clean signal
%    y: estimate
%
% OUTPUT       
%    SNR (dB)

x = x(:);
y = y(:);

SNR = 10 * log10(sum(abs(x).^2)/sum(abs(x-y).^2));