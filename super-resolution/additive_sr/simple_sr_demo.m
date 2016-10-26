grid = linspace(1, 3*pi, 64)';
signal = sin(grid);
signal = [signal; flipud(signal(1:end-1))]; %creates sharp edge
lambda = eps;
super_factor = 2;
signal_super = additive_sr_1d_HQ(signal, super_factor);

figure;
subplot(2, 1, 1); plot(signal); title('Original signal');
subplot(2, 1, 2); plot(signal_super); title('Additive SR with HQ reg');
