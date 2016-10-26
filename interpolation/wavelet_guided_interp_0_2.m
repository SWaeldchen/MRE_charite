function [u_interp, guidance_image, guidance_image_2] = wavelet_guided_interp_0_2(u, factor, T)
	sz = size(u);
	sz_interp = sz*factor;
	u_interp_x = zeros(sz(1), sz(2)*factor);
	u_interp = zeros(sz(1)*factor, sz(2)*factor);
	[af, ~] = FSfarras;
	w_re = dwt2D_stationary(u, 1, af{1});
	w_im = dwt2D_stationary(u, 1, af{2});
	w_re_x = w_re{1}{1};
	w_im_x = w_im{1}{1};
	w_abs_x = abs(w_re_x + 1i*w_im_x);
    guidance_image = w_abs_x;

	% INTERP X
	
	for i = 1:sz(1)
		row = u(i,:);
		w_abs_row = w_abs_x(i,:);
		jumps = find(w_abs_row > T);
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
				hi = sz(2);
			else
				hi = jumps(j);
            end
            if (hi - lo > 0)
                interpolants = cat(2, interpolants, lo:1/factor:hi);
                spl = cat(2, spl, spline(lo:1:hi, row(lo:1:hi), lo:1/factor:hi));
            end
		end
		[~, unique_index] = unique(interpolants);
        spl = [spl(unique_index) zeros(1, factor-1)];
		u_interp_x(i,:) = spl;
	end
	
	w_interp_x_re = dwt2D_stationary(u_interp_x, 1, af{1});
	w_interp_x_im = dwt2D_stationary(u_interp_x, 1, af{2});
	w_re_y = w_interp_x_re{1}{2};
	w_im_y = w_interp_x_im{1}{2};
	w_abs_y = abs(w_re_y + 1i*w_im_y);
    guidance_image_2 = w_abs_y;
    
	% INTERP Y
	
	for i = 1:sz_interp(2)
		col = u_interp_x(:,i);
		w_abs_col = w_abs_y(:,i);
		jumps = find(w_abs_col > T);
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
                spl = cat(1, spl, spline((lo:1:hi)', col(lo:1:hi), (lo:1/factor:hi)'));
            end
		end
		[~, unique_index] = unique(interpolants);
		spl = [spl(unique_index); zeros(factor-1,1)]; 
		u_interp(:,i) = spl;
	end

