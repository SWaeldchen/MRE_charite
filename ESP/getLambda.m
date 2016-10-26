
function nl_est = getLambda(U, curlFlag)
    if nargin < 2
        curlFlag = 0;
    end
	sz = size(U);
	midpts = floor(sz/2);
    if (numel(sz) < 3) 
        sample = middle_square(U);
        sample = sample - min(sample(:));
		nl_est = NLEstimate(sample);
 	else 
		nl_est = 0;
        for k = 1:sz(3)
		    sample = middle_square(U(:,:,k));
		    sample = sample - min(sample(:));
            nl_est = nl_est + NLEstimate(sample);
        end
        nl_est = nl_est / sz(3);
    end
end
