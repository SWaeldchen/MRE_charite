function [ mag_db, minpass, maxpass ] = cascade_kernels( kernels, plotTitle )
% Plots cascade of multiple kernels
% and identifies corner frequency

band = linspace(0, pi, 1024);
mag = ones(1,1024);
for n = 1:numel(kernels)
    [~, fr] = plot_fr_db(kernels{n}, 0);
    if size(fr,1) > 1 
        fr = fr';
    end
    mag = mag.*fr;
end
mag_db = 10*log10(mag / max(mag));
if (nargin >= 2)
    h = figure('name', plotTitle);
else
    h = figure();
end
plot(band, -3*ones(numel(band)), 'r', 'LineWidth', 3);
hold on;
plot(band, mag_db, 'b', 'LineWidth', 3);
passband = find(mag_db>-3);
startpass = min(passband);
breakLoop = 0;
endpass = 1;
while (breakLoop < 1) 
    if ( (endpass+1 <= numel(passband)) && ...
            (passband(endpass+1) == passband(endpass) + 1) )
        endpass = endpass + 1;
        breakLoop = 0;
    else
        breakLoop = 1;
    end
end
minpass = band(startpass);
maxpass = band(passband(endpass));
figure(h);
ylim([-20 0]);
xlim([0 pi]);
set(h, 'Position', [ 0 0 1000 400]);

title(['Passband corner frequencies: ', num2str(minpass), ', ', num2str(maxpass)]);

if (nargin < 2) 
    close(h)
end