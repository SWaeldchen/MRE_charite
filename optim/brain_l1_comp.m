function brain_l1_comp(brain_slice, lambda, maxiter)

brain_slice_tvl1 = tvl1_pd(double(brain_slice), lambda, maxiter, maxiter);
figure(1);
subplot(1, 3, 1); imshow(brain_slice, []);
subplot(1, 3, 2); imshow(brain_slice_tvl1, []);
subplot(1, 3, 3); imshow(brain_slice - brain_slice_tvl1, []);
