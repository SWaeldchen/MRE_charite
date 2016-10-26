function alpha_demo(freqvec)

omega = 2*pi*freqvec;
alpha_range = 0.1:0.05:0.9;
nomega = numel(omega);
nalpha = numel(alpha_range);
distrib = zeros(numel(freqvec), nalpha);

legend_entries = cell(0,0);
for f = 1:nalpha
    legend_entries = cat(1, legend_entries, num2str(alpha_range(f)));
end

for alpha = 1:nalpha
    distrib(:, alpha) = abs((1i.*omega).^alpha_range(alpha));
end

distrib_pct = distrib ./ repmat(distrib(1,:), [nomega 1]) * 100;
figure(1); set(gcf, 'name', 'Magnitude Distribution (%)');
cm=colormap(jet(nalpha));
for n = 1:nalpha
    plot(freqvec, distrib_pct(:,n), 'color', cm(n,:));
    hold on;
end
legend(legend_entries);
ylim([0 500]);
title('Magnitude Distribution (%)');
hold off;
