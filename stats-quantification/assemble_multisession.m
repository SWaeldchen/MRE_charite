function [magmont, phimont] = assemble_multisession(mag, phi);

magmont = [];
phimont = [];
sz = size(mag{1});
nsessions = size(mag);
for m = 1:sz(3)
    mrow = [];
    prow = [];
	for n = 1:nsessions
		mrow = cat(2, mrow, mag{n}(:,:,m));
		prow = cat(2, prow, phi{n}(:,:,m));
    end
    magmont = cat(3, magmont, mrow);
    phimont = cat(3, phimont, prow);
end
end


