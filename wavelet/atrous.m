function filt_atrous = atrous(filt, n)
filt_atrous = cell(1,2);
for I = 1:2
    interval = 2^(n-1);
    filt_atrous{I} = zeros(size(filt{I},1).*interval,size(filt{I},2));
    filt_atrous{I}(1:interval:end,:) = filt{I};
end

