function [k_mat] = build_k_mat(freqList, l_x, l_y)
%BUILD_K_MAT Summary of this function goes here
%   Detailed explanation goes here

numofFreq = length(freqList);

k_rows = zeros(2*numofFreq, 1);
k_cols = zeros(2*numofFreq, 1);
k_vals = zeros(2*numofFreq, 1);

for fr=1:numofFreq
   
    freq = freqList{fr};
    
    k_rows(fr) = freq(1) + ceil(l_x/2);
    k_rows(end-fr+1) = -freq(1) + ceil(l_x/2);
    
    k_cols(fr) = freq(2) + ceil(l_y/2);
    k_cols(end-fr+1) = -freq(2) + ceil(l_y/2);
    
    k_vals(fr) = freq(3);
    k_vals(end-fr+1) = freq(3);
    
end

k_mat = sparse(k_rows, k_cols, k_vals, l_x, l_y, 2*numofFreq);


end

