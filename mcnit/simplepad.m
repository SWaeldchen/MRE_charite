function y = simplepad(x, pad)
% y = simplepad(x,pad)
% Part of the MCNIT: M-code Complex and Nd Imaging Toolbox
% (c) Eric Barnhill 2016 All Rights Reserved.
%
% DESCRIPTION:
%
% A simpler way to zero pad. Enter the ND object, and a vector of n entries for the padded dims.
% These dimensions will be padded to the dims specified, and the others will be left alone.
%
% INPUTS:
%
% x - object
% pad - vector with padded dimensions, total dimensions less than or equal to x, all sizes larger than x
%
% OUTPUTS:
%
% y - object padded to specifications
	szx = size(x);
	n_pad = numel(pad);
	szy = [pad szx(n_pad+1:end)];
	y = zeros(szy);
	if ndims(x) < n_pad 
		disp('MCNIT error: simplepad requires num padding dims <= num object dims');
		return
	end
	if sum( pad - szx(1:n_pad) < 0 ) > 0
		disp('MCNIT error: simplepad requires all padding dims >= than orig dims.');
		return
	end
	[x_resh, num_objs] = resh(x, numel(pad) + 1);
	indices_string = '(';
	for n = 1:numel(szx)
		indices_string = [indices_string, '1:', num2str(szx(n))];
		if n < numel(szx)
			indices_string = [indices_string, ','];
		else
			indices_string = [indices_string, ')'];
		end
	end
	command = ['y',indices_string,'=x;'];
	eval(command);
end
