function [ym_, yp_, om_, op_,means,medians,sds,iqms] = young_old_summary_stats(ym, yp, om, op, noise_thresh)

nImages = size(ym,1);
means = zeros(nImages,4);
sds = zeros(nImages,4);
medians = zeros(nImages,4);
iqms = zeros(nImages,4);
ym_ = cell(size(ym));
yp_ = cell(size(yp));
om_ = cell(size(om));
op_ = cell(size(op));
margin = 5;
topz = 1+2;
bottomz = size(ym{1},3)-3;

for n = 1:nImages
	ym_{n} = ym{n}(margin:end-margin, margin:end-margin,topz:bottomz);
	yp_{n} = yp{n}(margin:end-margin, margin:end-margin,topz:bottomz);
	om_{n} = om{n}(margin:end-margin, margin:end-margin,topz:bottomz);
	op_{n} = op{n}(margin:end-margin, margin:end-margin,topz:bottomz);
	yind = find(ym_{n} > noise_thresh);
	y_mask = find(ym_{n} <= noise_thresh);
	oind = find(om_{n} > noise_thresh);
	o_mask = find(om_{n} <= noise_thresh);
	ym_{n}(y_mask) = 0; 
	yp_{n}(y_mask) = 0;
	om_{n}(o_mask) = 0;
	op_{n}(o_mask) = 0;
	means(n,1) = mean(ym_{n}(yind));
	sds(n,1) = std(ym_{n}(yind));
	medians(n,1) = median(ym_{n}(yind));	
	iqms(n,1) = mean(iqr(ym_{n}(yind)));
	means(n,2) = mean(om_{n}(oind));
	sds(n,2) = std(om_{n}(oind));
	medians(n,2) = median(om_{n}(oind));	
	iqms(n,2) = mean(iqr(om_{n}(oind)));
	means(n,3) = mean(yp_{n}(yind));
	sds(n,3) = std(yp_{n}(yind));
	medians(n,3) = median(yp_{n}(yind));	
	iqms(n,3) = mean(iqr(yp_{n}(yind)));
	means(n,4) = mean(op_{n}(yind));
	sds(n,4) = std(op_{n}(yind));
	medians(n,4) = median(op_{n}(yind));	
	iqms(n,4) = mean(iqr(op_{n}(yind)));
end

