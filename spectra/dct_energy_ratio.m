function b = dct_energy_ratio(a, ROI, cut, useROI)
if (nargin < 4) 
	useROI = 0;
end
sz = size(a);
b = zeros(sz(3),1);
for n = 3
    temp_a = a(:,:,n);
	if (useROI > 0)
		aa = zeros(size(temp_a));
		aa(ROI) = temp_a(ROI);
    	temp_a_dct = dct2(aa);
	else 
    	temp_a_dct = dct2(temp_a);
	end
    num = sum(sum(temp_a_dct(1:cut,1:cut).^2)) - temp_a_dct(1,1).^2;
    denom = temp_a_dct(1,1).^2;
    b(n) = num / denom;
end
