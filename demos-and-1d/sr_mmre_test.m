function [or naive sr] = sr_mmre_test(noplots, fignum)

if nargin < 2
	fignum = 1;
	if nargin < 1
		noplots = 0;
	end
end

or_sv_l1 = zeros(100,1);
naive_sv_l1 = zeros(100,1);
sr_sv_l1 = zeros(100,1);
or_sv_l2 = zeros(100,1);
naive_sv_l2 = zeros(100,1);
sr_sv_l2 = zeros(100,1);
or_spikes_l1 = zeros(100,1);
naive_spikes_l1 = zeros(100,1);
sr_spikes_l1 = zeros(100,1);
or_spikes_l2 = zeros(100,1);
naive_spikes_l2 = zeros(100,1);
sr_spikes_l2 = zeros(100,1);

h = waitbar(0,'Calculating...');
N = 100;
range = 1:N;
for n = range
	[l1_sv l2_sv] = sr_mmre_smooth_noplots(-1);
	[l1_spikes l2_spikes] = sr_mmre_smooth_noplots(0);
	or_sv_l1(n) = l1_sv(1);
	naive_sv_l1(n) = l1_sv(2);
	sr_sv_l1(n) = l1_sv(3);
	or_sv_l2(n) = l2_sv(1);
	naive_sv_l2(n) = l2_sv(2);
	sr_sv_l2(n) = l2_sv(3);
	or_spikes_l1(n) = l1_spikes(1);
	naive_spikes_l1(n) = l1_spikes(2);
	sr_spikes_l1(n) = l1_spikes(3); 
	or_spikes_l2(n) = l2_spikes(1);
	naive_spikes_l2(n) = l2_spikes(2);
	sr_spikes_l2(n) = l2_spikes(3); 
	waitbar(n / N)
end  
close(h)

or = {or_sv_l1, or_sv_l2, or_spikes_l1, or_spikes_l2};
naive = {naive_sv_l1, naive_sv_l2, naive_spikes_l1, naive_spikes_l2};
sr = {sr_sv_l1, sr_sv_l2, sr_spikes_l1, sr_spikes_l2};
legend_entries = {'Original Resolution', 'Naive Upsampling', 'Super Resolution'};

if (noplots == 0)
	set(0,'DefaultLineLineWidth',2)
	fig = figure(fignum);
	set(fig, 'Color', 'w');
	set(fig, 'Position', [300 300 2400 1600]);
	subplot(2, 2, 1); plot(range, or{1}, range, naive{1}, range, sr{1}); title('MAE Slowly Varying'); 
	leg = legend(legend_entries); set(legend, 'FontSize', 28);
	subplot(2, 2, 2); plot(range, or{2}, range, naive{2}, range, sr{2}); title('MSE Slowly Varying');
	subplot(2, 2, 3); plot(range, or{3}, range, naive{3}, range, sr{3}); title('MAE Random Spikes');
	subplot(2, 2, 4); plot(range, or{4}, range, naive{4}, range, sr{4}); title('MSE Random Spikes');
end
