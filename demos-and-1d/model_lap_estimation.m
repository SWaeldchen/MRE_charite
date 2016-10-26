function [u, pg, g, lapu] = model_lap_estimation

	xmax = 64;
	%get inversion results
	[u, pg] = steadily_increasing_complex_wave;
	pg = (gradient(unwrap(angle(u))));
	pg(isnan(pg) | isinf(pg)) = 0;
	lapu = lap(u);
	g = abs(u)./abs(lapu);
	% get interpolated results
	pg_interp = spline_interp(pg,4);
	u_interp = spline_interp(u,4);
	lapu_interp = lap(u_interp) * 16;
	g_interp = abs(u_interp) ./ abs(lapu_interp);
	% normalize results
	or_range = 3:xmax-2;
	sr_range = 13:xmax*4-12;
	%pg_norm = normalize(pg(or_range));
	%g_norm = normalize(g(or_range));
	%pg_interp_norm = normalize(pg_interp(sr_range));
	%g_interp_norm = normalize(g_interp(sr_range));
	pg_norm = pg(or_range);
	g_norm = g(or_range);
	pg_interp_norm = pg_interp(sr_range);
	g_interp_norm = g_interp(sr_range);

	figure(1); 
	set(gcf, 'Color', 'w');
	set(gcf, 'Position', [300 300 1200 800]);
	set(gcf, 'Name', 'Steadily Increasing Curve And Its Stiffness Estimation');
	subplot(2, 4, 1); complex_plot(u,'Complex Wavefield', 0, 1); xlim([2 xmax-1]);
	subplot(2, 4, 2); plot(g_norm); title('Stiffness Estimate'); xlim([2 xmax-1]);
	subplot(2, 4, 3); plot(pg_norm); title('Ground Truth'); xlim([2 xmax-1]);
	subplot(2, 4, 4); plot(g_norm-pg_norm); title('Diff'); xlim([2 xmax-1]);
	subplot(2, 4, 5); complex_plot(u_interp,'Complex Wavefield', 0, 1); xlim([5 xmax*4-4]);	
	subplot(2, 4, 6); plot(g_interp_norm); title('Interp'); xlim([5 xmax*4-4]);
	subplot(2, 4, 7); plot(pg_interp_norm); title('Ground Truth'); xlim([5 xmax*4-4]);		
	subplot(2, 4, 8); plot(g_interp_norm-pg_interp_norm); title('Interp Diff'); xlim([5 xmax*4-4]);




end

function x_n = normalize(x)
	x(isnan(x) | isinf(x)) = 0;
	x_n = (x - min(x(:))) / (max(x(:)) - min(x(:)));
end
