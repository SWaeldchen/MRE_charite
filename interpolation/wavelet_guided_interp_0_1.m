function u_interp = wavelet_guided_interp(u, factor, T)
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


	% INTERP X
	
	for i = 1:sz(1)
		row = u(i,:);
		w_abs_row = w_abs_x(i,:);
		jumps = find(w_abs_row > T);
		num_jumps = numel(jumps);
		sites = [];
		vals = [];
		interpolants = [];
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
			sites = cat(2, sites, lo:1:hi);
			vals = cat(2, vals, row(lo:1:hi));
			interpolants = cat(2, interpolants, lo:1/factor:hi);
		end
		[unique_sites, unique_index] = unique(sites);
		interpolants = [unique(interpolants) zeros(1, factor-1)]; 
		u_interp_x(i,:) = spline(unique_sites, vals(unique_index), interpolants);
	end
	
	w_interp_x_re = dwt2D_stationary(u_interp_x, 1, af{1});
	w_interp_x_im = dwt2D_stationary(u_interp_x, 1, af{2});
	w_re_y = w_interp_x_re{1}{2};
	w_im_y = w_interp_x_im{1}{2};
	w_abs_y = abs(w_re_y + 1i*w_im_y);

	% INTERP Y
	
	for i = 1:sz_interp(2)
		col = u_interp_x(:,i);
		w_abs_col = w_abs_y(:,i);
		jumps = find(w_abs_col > T);
		num_jumps = numel(jumps);
		sites = [];
		vals = [];
		interpolants = [];
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
			sites = cat(1, sites, (lo:1:hi)');
			vals = cat(1, vals, col(lo:1:hi));
			interpolants = cat(1, interpolants, (lo:1/factor:hi)');
		end
		[unique_sites, unique_index] = unique(sites);
		interpolants = [unique(interpolants); zeros(factor-1,1)]; 
		u_interp(:,i) = spline(unique_sites, vals(unique_index), interpolants);
	end

