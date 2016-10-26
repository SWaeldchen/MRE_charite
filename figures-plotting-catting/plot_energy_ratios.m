function plot_energy_ratios(stack, ROI)
% l = min(size(stack,1), size(stack,2));
cuts = 2:2:8;
numcuts = numel(cuts);
figure(); hold on; 
j = colormap(gcf, jet(numcuts));
for cut = 1:numcuts
    plot(normalizeImage(dct_energy_ratio(stack, ROI, cuts(cut))), 'Color', j(cut, :));
end
hold off;

