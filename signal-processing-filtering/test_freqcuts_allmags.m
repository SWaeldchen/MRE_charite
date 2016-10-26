function [cs, mcds] = test_freqcuts_allmags(mags)

sz = size(mags);
szim = size(mags{1,1});
cuts = -5:0.1:0;
cs = zeros(numel(cuts), sz(1), sz(2), szim(3));
mcds = zeros(numel(cuts), sz(1), sz(2), szim(3));

for i = 1:sz(1)
    for j = 1:sz(2)
        for k = 3:szim(3)-2
            for m = 1:numel(cuts)
                
                [c, mcd] = test_frequency_cuts(mags{i,j}(:,:,k), cuts(m));
                cs(m,i,j,k) = c;
                mcds(m,i,j,k) = mcd;
            end
        end
    end
end
cs = reshape(cs, m, sz(1)*sz(2)*szim(3));
mcds = reshape(mcds, m, sz(1)*sz(2)*szim(3));

            