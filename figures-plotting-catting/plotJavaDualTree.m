function plotJavaDualTree(L)

sz1 = size(L);
legendStrings = [];
figure(); hold on;
for i = 1:sz1
    sz2 = size(L.get(i-1));
    for j = 1:sz2
        plot(L.get(i-1).get(j-1), 'LineWidth', 3);
        legendStrings = cat(1, legendStrings,[num2str(i), ' ', num2str(j)]);
    end
end
legend(legendStrings);
title('Java Dual Tree');
%ylim([-.001 .001]);
hold off;