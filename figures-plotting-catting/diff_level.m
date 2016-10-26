function diff_level(img, n)

[gradX, gradY] = DT_diff(img, n);
figure(); 
subplot(1, 2, 1); imagesc(gradX);
subplot(1, 2, 2); imagesc(gradY);