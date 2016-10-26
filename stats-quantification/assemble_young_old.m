function [magmont, phimont] = assemble_young_old(ym, yp, om, op);

magmont = [];
phimont = [];
sz = size(ym{1});

for m = 1:sz(3)
	mmont = [];
	pmont = [];
	slicemont = [];
	for n = 1:5
		mrow = [];
		prow = [];
		mrow = cat(2, ym{n}(:,:,m), om{n}(:,:,m));
		mmont = cat(1, mmont, mrow);
		prow = cat(2, yp{n}(:,:,m), op{n}(:,:,m));
		pmont = cat(1, pmont, prow);
	end
	magmont = cat(3, magmont, mmont);
	phimont = cat(3, phimont, pmont);
end


