function [w] = subband_thresh_dwt_3D(w, T, J, meth)
if nargin < 4
	meth = 1;
	if nargin < 3
		J = 2;
		if nargin < 2
			T = 0.25;
		end
	end
end
K = [3 3 3];
for j = 1:J
    for n = 1:size(w,2)
        switch meth
            case 1
                 w{j}{n} = ogs3( w{j}{n}, K, T, 'atan', 1, 5);
            case 2
                c = max(abs(w{j}{n}) - T, 0);
                 w{j}{n} = c./(c+T) .*  w{j}{n};
            case 3
                C = w{j}{n};
                C = ( C - T^2 ./ C ) .* (abs(C) > T);  
                w{j}{n} = C;
        end    
    end
end



