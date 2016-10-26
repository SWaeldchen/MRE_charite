function [band, mag_db, mag, resp] = plotFreqResp(kernel, output)
if (isvector(kernel) == 1) 
    spike = zeros(size(kernel));
    spike(1) = 1;
    [resp, band] = freqz(kernel, spike, 1024);
    mag = abs(resp);
    mag_db = 10*log10(mag/max(mag));
    if (nargin > 1) 
        figure(); 
        subplot(2, 1, 1), plot(band, mag);
        subplot(2, 1, 2), plot(band, mag_db);
        hold on;
        ylim([-20,0]);
        stopvals = find(mag_db<-3);
        stopIndex = min(stopvals);
        stopband = band(stopIndex);
        stopPoint = zeros(size(band));
        stopPoint(stopIndex) = mag_db(stopIndex);
        plot(band(stopIndex), mag_db(stopIndex), 'r*', 'MarkerSize', 12);
        display(['-3 dB stopband : ',num2str(stopband)]);
    end
else
    display('1D kernels only');
end
    