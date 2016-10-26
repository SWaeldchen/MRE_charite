function [catresult] = catMagComps(storComps, lossComps)

magComps = squeeze(sqrt(storComps.^2 + lossComps.^2));
sz = size(magComps);
catresult = zeros(0);
for n = 1:sz(4)
    catresult = cat(2, catresult, magComps(:,:,:,n));
end