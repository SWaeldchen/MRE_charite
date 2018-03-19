function filt = butterworth_3d(ord, cut, dims, hi)

if nargin < 4
    hi = 0;
end

mids = floor(dims/2);
[x, y, z] = meshgrid( (1:dims(2)) - mids(2), (1:dims(1)) - mids(1), (1:dims(3)) - mids(3));
w = sqrt(x.^2 + y.^2 + z.^2);
w = w ./ max(w(:));
w = w / cut;
filt = sqrt(1 ./ (1 + w.^(2*ord)));
if hi == 1
	filt = 1 - filt;
end
