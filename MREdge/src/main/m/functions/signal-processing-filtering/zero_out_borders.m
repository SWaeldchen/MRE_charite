function y = zero_out_borders(x, factor)
	x = squeeze(x);
    sz = size(x);
    y = zeros(sz);
    for n = 1:sz(3)
        x(1:factor*2, 1:sz(2),n) = 0;
        x((sz(1)-factor*2):sz(1), 1:sz(2),n) = 0;
        x(1:sz(1), 1:factor*2,n) = 0;
        x(1:sz(1), (sz(2)-factor*2):sz(2),n) = 0;
        y = x;
    end
end
