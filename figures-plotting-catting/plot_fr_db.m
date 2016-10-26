function [frdb, fr, band] = plot_fr_db(b, output)

outputIndex = 2;


if numel(b) == 2
    band = linspace(0, pi, 1024);
    fr = fft(b{1}, 2048);
    fr = fr(1:1024);
    outputIndex = 3;
    fr2 = fft(b{2}, 2048);
    fr2 = fr2(1:1024);
    fr = fr ./ fr2;
else
    band = linspace(0, pi, 1024);
    fr = fft(b, 2048);
    fr = fr(1:1024);
end
fr = abs(fr);
frdb = 10*log10(fr / max(fr));
if (output > 0 )
    h = figure();
    plot(band, frdb);
    ylim([-30,0]);
    xlim([0,3.2]);
    set(h, 'Position', [ 0 0 1000 400])
end
