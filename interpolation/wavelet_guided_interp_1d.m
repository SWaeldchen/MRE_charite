function [u_interp, guidance_image, jumps] = wavelet_guided_interp_1d(u, factor, T, jumps)
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
		guidance_image = w_abs;
        %guidance_image = abs(lap(u));
		assignin('base', 'guidance_image', guidance_image);
		jumps = strip_neighbors(find(guidance_image > T));
		%figure(); plot(guidance_image); pause(0.5);
		%figure(); complexPlot(w_re{1}+1i*w_im{1});
    end
    % remove back end of jump
    %jumps = strip_neighbors(jumps);
    num_jumps = numel(jumps);
    interpolants = [];
    spl_r = [];
    spl_i = [];
    for j = 1:num_jumps+1
        if j == 1
            lo = 1;
        else 
            lo = jumps(j-1);
        end
        if j == num_jumps+1
            hi = sz(1);
       else
            hi = jumps(j);
        end
        if hi - lo > 2
            interpolants = cat(1, interpolants,  (lo+1/factor:1/factor:hi-1/factor)');
            spl_r = cat( 1, spl_r, u_r(lo), spline((lo+1:1:hi-1)', u_r(lo+1:1:hi-1)', (lo+1/factor:1/factor:hi-1/factor)'), u_r(hi) );
            spl_i = cat( 1, spl_i, u_i(lo), spline((lo+1:1:hi-1)', u_i(lo+1:1:hi-1)', (lo+1/factor:1/factor:hi-1/factor)'), u_i(hi) );
       %{
        elseif hi - lo == 1
			interpolants = cat(1, interpolants, (lo:1/factor:hi)');
			in_r = interp1((lo:hi)', u_r(lo:hi)',(lo:1/factor:hi)');
			spl_r = cat(1, spl_r, [u(lo); in_r; u(hi)]); 
			in_i = interp1((lo:hi)', u_i(lo:hi)',(lo:1/factor:hi)');
			spl_i = cat(1, spl_i, [u(lo); in_i; u(hi)]); 
        %}
	   end
    end
    [int, unique_index] = unique(interpolants);
    assignin('base', 'int', int);
	%display(int)
    spl_r = [u_r(1); spl_r(unique_index); zeros(factor-1,1)];
    spl_i = [u_r(1); spl_i(unique_index); zeros(factor-1,1)];
    spl = spl_r + 1i*spl_i;
    if (numel(spl) > numel(u_interp))
        u_interp = spl(1:numel(u_interp));
    else
        u_interp(1:numel(spl)) = spl;
    end
end

