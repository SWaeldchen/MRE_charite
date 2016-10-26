function [u_interp, guidance_image, jumps] = wavelet_guided_interp_1d(u, factor, T, jumps)
	sz = size(u);
	sz_interp = sz*factor;
	[af, ~] = FSfarras;
	if nargin < 4
		w_re = dwt_stationary(u, 1, af{1});
		w_im = dwt_stationary(u, 1, af{2});
    	w_abs = abs(w_re{1} + w_im{1});
		guidance_image = w_abs;
		jumps = find(w_abs > T)
	end
    num_jumps = numel(jumps);
    interpolants = [];
    spl = [];
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
        if (hi - lo > 0)
            interpolants = cat(1, interpolants, (lo:1/factor:hi)');
            spl = cat(1, spl, interp1((lo:1:hi)', u(lo:1:hi)', (lo:1/factor:hi)', 'linear'));
       end
    end
    [~, unique_index] = unique(interpolants);
    spl = [spl(unique_index); zeros(factor-1,1)];
    u_interp = spl;


