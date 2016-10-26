xh = x{4};
snip = xh(56:84);
figure(1);
subplot(3, 3, 1); complexPlot(snip(4:24));
snip_ds = snip(1:2:end);
subplot(3, 3, 2); complexPlot(snip_ds(2:12));
snip_rs = polar_interp(snip_ds, 2, 4);
subplot(3, 3, 3); complexPlot(snip_rs(4:24));

grad = convn(snip, [1; -1], 'valid');
grad_ds = convn(snip_ds, [1; -1], 'valid');
grad_rs = convn(snip_rs, [1; -1], 'valid');
subplot(3, 3, 4); complexPlot(grad(4:24));
subplot(3, 3, 5); complexPlot(grad_ds(2:12));
subplot(3, 3, 6); complexPlot(grad_rs(4:24));

lap = convn(snip, laplacian, 'valid');
lap_ds = convn(snip_ds, laplacian, 'valid');
lap_rs = convn(snip_rs, laplacian, 'valid');
subplot(3, 3, 7); complexPlot(lap(4:24));
subplot(3, 3, 8); complexPlot(lap_ds(2:12));
subplot(3, 3, 9); complexPlot(lap_rs(4:24));

