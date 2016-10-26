

[ym1x_, yp1x_, om1x_, op1x_,means1x,medians1x,sds1x,iqms] = young_old_summary_stats(ym1x, yp1x, om1x, op1x, thresh);
[ym_sr_, yp_sr_, om_sr_, op_sr_,means_sr,medians_sr,sds_sr,iqms] = young_old_summary_stats(ym_sr, yp_sr, om_sr, op_sr, thresh);
numels = round(numel(means1x)/2);
means1x_ = means1x(1:numels);
minimax_1x = (max(means1x_) - min(means1x_)) / mean(means1x_)
means_sr_ = means_sr(1:numels);
minimax_sr = (max(means_sr_) - min(means_sr_)) / mean(means_sr_)

figure(1);
plot(1:numels, means1x_, 1:numels, means_sr_);

display(mean(means1x_ - means_sr_) / mean(means1x_)*100)
