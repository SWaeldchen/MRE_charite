function [newData, mini, maxi] = normalize_image(data)

mini = min(data(:));
maxi = max(data(:));

newData = (data - mini)./(maxi-mini);

