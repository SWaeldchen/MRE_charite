function [u_interp, guidance_image, guides] = wavelet_guided_interp_java(u, factor, T, jumps)
	sz = size(u);
	sz_interp = [sz(1)*factor, sz(2)];
    u_interp = zeros(sz_interp);
    u_r = real(u)';
    u_i = imag(u)';
	[af, ~] = FSfarras;
    if nargin < 4
		w_re = dwt_stationary(u, 1, af{1});
		w_im = dwt_stationary(u, 1, af{2});
    	w_abs = abs(w_re{1} + 1i*w_im{1});
		%guidance_image = w_abs;
		guidance_image = abs(lap(u));
    end
	jumps = guidance_image > T;
	%display(['jumps: ',num2str(jumps')])
  	gi = com.ericbarnhill.esp.GuidedInterpolator(5);
	debuglo = 0;
	debughi = 0;
	u_interp_real = gi.interp(real(u), 0:(sz(1)-1), 0:1/factor:(sz(1)-1/factor-1), jumps, debuglo, debughi, factor);
	u_interp_imag = gi.interp(imag(u), 0:(sz(1)-1), 0:1/factor:(sz(1)-1/factor-1), jumps, debuglo, debughi, factor);
	guides = gi.getGuidesLogical();
	u_interp = u_interp_real + 1i*u_interp_imag;
end

