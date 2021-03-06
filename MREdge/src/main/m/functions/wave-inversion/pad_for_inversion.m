function [U_pad, order_vector] = pad_for_inversion(U)

MIN_PADDING = 10;
sz = size(U);
if numel(sz) > 4 || numel(sz) < 3
    disp('Padding:Inversion data not valid.')
end
if numel(sz) < 4
    d4 = 1;
else
    d4 = sz(4);
end

% need to get at least 20 extra slices

origDepth = sz(3);

dimZ = max(origDepth*3, origDepth*2 + MIN_PADDING);

if sz(1) < MIN_PADDING || sz(2) < MIN_PADDING
    disp(['Padding error, not implemented for x or y less than', num2str(MIN_PADDING)]);
end

dimX = sz(2)+MIN_PADDING;
dimY = sz(1)+MIN_PADDING;

tile = origDepth*2-2;
order_vector = zeros(dimZ,1);

U_pad = zeros(dimX, dimY, dimZ, d4);

for n = 1 :	dimZ
    m = n-1;
    index =  mod((m), tile)+1;
    if index < origDepth
        curSlc = origDepth - index + 1;
    end
    
    if index >= origDepth 
        curSlc = index - origDepth + 1;
    end
    U_pad(1:sz(1),1:sz(2),n,:) = U(:,:,curSlc,:);
    order_vector(n) = curSlc;
end 

U_pad(end-MIN_PADDING+1:end, :, :, :) = U_pad(end-MIN_PADDING:-1:end-2*MIN_PADDING+1, :, :, :); 
U_pad(:, end-MIN_PADDING+1:end, :, :) = U_pad(:, end-MIN_PADDING:-1:end-2*MIN_PADDING+1, :, :); 
