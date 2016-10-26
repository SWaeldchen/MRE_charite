function [newData, mini, maxi] = normalize_image(data);

mini = min(min(data));
maxi = max(max(data));

newData = (data - mini)./(maxi-mini);

