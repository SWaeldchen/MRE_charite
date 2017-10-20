function BW = largestBW(BW)

for kslice = 1:size(BW,3)
    if ( sum(sum(BW(:,:,kslice))) == 0 )
        TMP_BW(:,:,kslice) = BW(:,:,kslice);
    else
        TMP_BW(:,:,kslice) = getLargestCc(logical(BW(:,:,kslice)),4,1);
    end
end

BW = TMP_BW;

end