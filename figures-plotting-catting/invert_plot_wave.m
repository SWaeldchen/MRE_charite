function invert_plot_wave(wave)

if size(wave,1) == 1
	wave = permute(wave, [2 1]);
end

full_range = size(wave,1);
display_range = round(full_range/4):round(3*full_range/4);

figure();
subplot(3, 1, 1); complexPlot(wave(display_range), 'Wave', 0, 1);

wave_lap = lap(wave);
subplot(3, 1, 2); complexPlot(wave_lap(display_range), 'Lap', 0, 1);

wave_g = abs(wave) ./ abs(wave_lap);
subplot(3, 1, 3); plot(wave_g(display_range));
