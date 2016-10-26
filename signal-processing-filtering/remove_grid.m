function [U_filt] = remove_grid(U, grid_size, grid_offset)

if isreal(U)
	U_filt = com.ericbarnhill.ESP.GridRemover.removeGrid(U, grid_size, grid_offset);
elseif ~isreal(U)
	U_r = real(U);
	U_i = imag(U);
	U_r_filt = com.ericbarnhill.ESP.GridRemover.removeGrid(U_r, grid_size, grid_offset);
	U_i_filt = com.ericbarnhill.ESP.GridRemover.removeGrid(U_i, grid_size, grid_offset);
	U_filt = U_r_filt + 1i*U_i_filt;
end
