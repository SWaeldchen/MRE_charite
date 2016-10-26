function plot_stiffness_vs_sharpness(stack, ROI, title_, useROI, yLim, yTicks, smoothingUnit, xLab)
stack = squeeze(stack);
sz = size(stack);
figure(); 
set(gcf, 'color', 'w');
[hAx, hLine1, hLine2] = plotyy((1:sz(3))*smoothingUnit, mean_by_slice(stack, ROI), (1:sz(3))*smoothingUnit, dct_energy_ratio(stack, ROI, 16, useROI));
ylabel(hAx(1), '$\mathbf{|G^{*}|}$', 'Interpreter', 'LaTeX');
ylabel(hAx(2), 'RER', 'FontWeight', 'Bold');
xlabel(xLab);
set(hLine1, 'LineWidth', 3);
set(hLine2, 'LineWidth', 3);
set(hAx(1), 'FontSize', 14);
set(hAx(2), 'FontSize', 14);
set(gca, 'Position', [.2, .15, .6, .75]);
title(title_);
if (nargin >= 5)
    ylim(hAx(1), yLim);
    if (nargin < 5) 
        yTicks = 1;
    end
    set(hAx(1), 'YTick', yLim(1):(yLim(2)-yLim(1))/yTicks:yLim(2));
    lims = ylim(hAx(2));
    set(hAx(2), 'YTick', lims(1):(lims(2)-lims(1))/yTicks:lims(2));
end
