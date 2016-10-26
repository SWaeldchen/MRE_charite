function mags = florian_three_bears (U_denoise)
  
  
	U_lsqr = hodge_decomp(U_denoise, 1, 3);
  	U_fd = hodge_decomp(U_denoise, 0, 0);
    U_none = U_denoise;
  
	mag_lsqr = invert_bear(U_lsqr);
    mag_fd = invert_bear(U_fd);
    mag_none = invert_bear(U_none);
    
    mags = {mag_lsqr, mag_fd, mag_none};  

end


function [mag] = invert_bear(U);
  
    spacing = [.002 .002 .002];
    freqvec = [18 20 22];
    super_factor = 1;
    twoD = 0;
    
  
    [magNum, magDenom, phiNum, phiDenom] = invert(U, spacing, freqvec, super_factor, twoD);
    mag = magNum ./ magDenom;
        mag(isnan(mag)) = 0;


end	