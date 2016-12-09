function U_FT = temporal_ft(U)

U_FT = fft(U, [], 4);
U_FT = squeeze(U_FT(:,:,:,2,:,:));