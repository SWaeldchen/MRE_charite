freq1b = repmat(squeeze(fem3(:,:,3,:,3,1)), [1 1 5]);
freq2b = repmat(squeeze(fem3(:,:,3,:,3,2)), [1 1 6]);
freq3b = repmat(squeeze(fem3(:,:,3,:,3,3)), [1 1 7]);
freq4b = repmat(squeeze(fem3(:,:,3,:,3,4)), [1 1 8]);

freq1e = shiftdim(imresize(shiftdim(normalizeImage(flipud(freq1b)),2), [500, 80]),1);
freq2e = shiftdim(imresize(shiftdim(normalizeImage(flipud(freq2b)),2), [500, 80]),1);
freq3e = shiftdim(imresize(shiftdim(normalizeImage(flipud(freq3b)),2), [500, 80]),1);
freq4e = shiftdim(imresize(shiftdim(normalizeImage(flipud(freq4b)),2), [500, 80]),1);

freqs = cat(2, freq1e, freq2e, freq3e, freq4e);
openImage(freqs, MIJ);