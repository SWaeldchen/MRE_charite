function [naive_pf, sr_pf] = old_young_passed_freq_coverage(ym_1x, om_1x, ym_sr, om_sr, fac);

nImages = 5;

naive_pf = zeros(nImages*2,1);
sr_pf = zeros(nImages*2,1);


for n = 1:nImages
	index = (n-1)*2+1;
	naive_pf(index) = passed_freq_coverage(interp_3d(ym_1x{n}, 4));
	naive_pf(index+1) = passed_freq_coverage(interp_3d(om_1x{n}, 4));
	sr_pf(index) = passed_freq_coverage(suppress_ringing_mre(ym_sr{n}));
	sr_pf(index+1) = passed_freq_coverage(suppress_ringing_mre(om_sr{n}));
end



end


function y = ctr(x)
	sz = size(x);
	ctr_sl = round(sz(3) /2);
	y = x(:,:,ctr_sl);
end

