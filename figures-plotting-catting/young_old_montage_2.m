function [magmont, phimont] = young_old_montage_2(ym, yp, om, op);
sz = size(ym{1});
magmont = [];
phimont = [];

for k = 1:sz(3)
	magslc = [];
	phislc = [];
	for n = 1:5
		magrow = cat(2, ym{n}(:,:,k), om{n}(:,:,k));
		phirow = cat(2, yp{n}(:,:,k), op{n}(:,:,k));
		magslc = cat(1, magslc, magrow);
		phislc = cat(1, phislc, phirow);
	end
	magmont = cat(3, magmont, magslc);
	phimont = cat(3, phimont, phislc);
end


end

