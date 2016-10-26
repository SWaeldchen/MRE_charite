function plotMatlabDualTree(L)

sz1 = size(L,2);
legendStrings = [];
figure(); hold on;
for i = 1:sz1
    sz2 = size(L{i},2);
    for j = 1:sz2
        plot(L{i}{j}, 'LineWidth', 3);
        legendStrings = cat(1, legendStrings,[num2str(i), ' ', num2str(j)]);
    end
end
legend(legendStrings);
title('Matlab Dual Tree');
%ylim([-.001 .001]);
hold off;
        
        