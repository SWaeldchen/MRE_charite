function y = wavelet_interp_2d(x, T, factor)

	sz = size(x);
	[af, sf] = FSfarras;
	w_re = dwt2D(x, 1, af{1});
	w_im = dwt2D(x, 1, af{2});

	w_re_interp = cell(1,2);
	w_re_interp{1} = cell(1,3);
	w_im_interp = cell(1,2);
	w_im_interp{1} = cell(1,3);
	w_re_interp{2} = complex_spline_interp(w_re{2}, factor);
	w_im_interp{2} = complex_spline_interp(w_im{2}, factor);
	for n = 1:3
		w_re_interp{1}{n} = complex_spline_interp(w_re{1}{n}, factor);
		w_im_interp{1}{n} = complex_spline_interp(w_im{1}{n}, factor);
	end

	%{
	[w_re_interp{1}{1}, w_im_interp{1}{1}] = interp_hipass(w_re{1}{1}, w_im{1}{1}, T, factor);
	[w_re_interp{1}{2}, w_im_interp{1}{2}] = interp_hipass(w_re{1}{2}, w_im{1}{2}, T, factor);
	[w_re_interp{1}{3}, w_im_interp{1}{3}] = interp_hipass(w_re{1}{3}, w_im{1}{3}, T, factor);
	%}

	y1 = idwt2D(w_re_interp, 1, sf{1});
	y2 = idwt2D(w_im_interp, 1, sf{2});

	assignin('base', 'w_re', w_re{1}{1});
	assignin('base', 'w_im', w_im{1}{1});

	y = (y1 + y2) / 2;

end

function [re_interp, im_interp] = interp_hipass(re, im, T, factor)

	sz = size(re);
	re_interp = zeros(sz*factor);
	im_interp = zeros(sz*factor);
	%{
	for y = 1:sz(1)
		for x = 1:sz(2)
			if (abs(re(y,x) + 1i*im(y,x)) > T)
				re_interp(y*factor, x*factor) = re(y, x);
				im_interp(y*factor, x*factor) = im(y, x);
			end
		end
	end
	%}
	w_abs = abs(re + 1i*im);
	re(w_abs < T) = 0;
	im(w_abs < T) = 0;
	

end

