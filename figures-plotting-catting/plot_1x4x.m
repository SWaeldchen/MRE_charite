 figure(1); 
 plot(1:10, means1x, 'linewidth', 3, 1:10, means4x, 'linewidth', 3);
set(gca, 'fontsize', 18)
xlim([1 10])
 ylabel('|G*| (Pa)');
 xlabel('Subject');
 l = legend('1x', '4x');
set(l, 'location', 'northeast')
set(l, 'fontsize', 18)
