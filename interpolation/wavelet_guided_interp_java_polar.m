function [u_interp, guidance_image, guides] = wavelet_guided_interp_java_polar(u, factor, T, jumps)
	sz = size(u);
	sz_interp = [sz(1)*factor, sz(2)];
    u_interp = zeros(sz_interp);
	[af, ~] = FSfarras;
    if nargin < 4
		w_re = dwt_stationary(u, 1, af{1});
		w_im = dwt_stationary(u, 1, af{2});
    	w_abs = abs(w_re{1} + 1i*w_im{1});
		guidance_image = w_abs;
    end
	jumps = guidance_image > T;
	u_re = real(u);
	u_im = imag(u);
	[t, r] = cart2pol(u_re, u_im);
	t = exp(-1i.*t);
	t_re = real(t);
	t_im = imag(t);
  	gi = com.ericbarnhill.esp.GuidedInterpolator(10);
	r = gi.interp(r, 0:(sz(1)-1), 0:1/factor:(sz(1)-1/factor-1), jumps, 32-1, 44-1, factor);
	t_re = gi.interp(t_re, 0:(sz(1)-1), 0:1/factor:(sz(1)-1/factor-1), jumps, 32-1, 44-1, factor);
	t_im = gi.interp(t_re, 0:(sz(1)-1), 0:1/factor:(sz(1)-1/factor-1), jumps, 32-1, 44-1, factor);
	t = angle(t_re + 1i*t_im);
	[y_re, y_im] = pol2cart(t, r);
	u_interp = y_re + 1i*y_im;
	guides = gi.getGuidesLogical();

end

