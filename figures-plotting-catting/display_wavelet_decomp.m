function display_wavelet_decomp(w, MIJ, maxJ)

if nargin < 3
    maxJ = numel(w)-1;
end
    

for j = 1:maxJ
    K = numel(w{j});
    for k = 1:K
        openImage(w{j}{k}, MIJ, [num2str(j), ' ', num2str(k)]);
    end
end
openImage(w{numel(w)}, MIJ, 'scaling');
             
    