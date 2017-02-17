function sumstats(object)

mean_ = mean(object(:));
min_ = min(object(:));
max_ = max(object(:));
std_ = std(object(:));
range_ = range(object(:));
median_ = median(object(:));

disp(['Min: ',num2str(min_),' Max: ', num2str(max_), ' Mean: ', num2str(mean_), ...
    ' Median: ', num2str(median_), ' Std: ', num2str(std_), ' Range: ', num2str(range_) ]);