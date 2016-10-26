function filt_atrous = atrous_dwt(filt, n, plot)
if nargin < 3 
	plot = 0;
end
filt_atrous = cell(1,2);
interval = 2^(n-1);
filt_atrous = zeros(size(filt,1).*interval,size(filt,2));
filt_atrous(1:interval:end,:) = filt;
if plot > 0
	figure(); plot(filt_atrous)
end
