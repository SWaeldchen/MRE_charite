function [mag_, means,medians,sds,iqms] = multisession_summary_stats(mag, noise_thresh)

mag_ = cell(size(mag));
means = zeros(5,1);
sds = zeros(5,1);
medians = zeros(5,1);
iqms = zeros(5,1);
margin = 5;
topz = 2;
bottomz = size(mag{1},3) - 1;

for n = 1:size(mag)
	mag_{n} = mag{n}(margin:end-margin, margin:end-margin,topz:bottomz);
	%mag_{n} = mag{n}(margin:end-margin, margin:end-margin,10);	
	mag_ind = find(mag_{n} > noise_thresh);
	mag_mask = find(mag_{n} <= noise_thresh);
	mag_{n}(mag_mask) = 0; 
	means(n,1) = mean(mag_{n}(mag_ind));
	sds(n,1) = std(mag_{n}(mag_ind));
	medians(n,1) = median(mag_{n}(mag_ind));	
	iqms(n,1) = mean(iqr(mag_{n}(mag_ind)));
end

minimax = max(means) - min(means);
display(['MINIMAX ', num2str(minimax), ' as percent ', num2str(minimax / mean(means))]);
op