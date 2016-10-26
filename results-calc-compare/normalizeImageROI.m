function [newData] = normalizeImageROI(data, ROI);

mini = min(min(data(ROI)));
maxi = max(max(data(ROI)));

newData = (data - mini)./(maxi-mini);

