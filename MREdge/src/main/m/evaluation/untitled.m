c1 = 2*rand(5,5);
c2 = 2*rand(5,5) + 1;

figure;
subplot(1,2,1);
imagesc(c1);
caxis([0 3]);

subplot(1,2,2);
imagesc(c2);
caxis([0 3]);
colorbar;
