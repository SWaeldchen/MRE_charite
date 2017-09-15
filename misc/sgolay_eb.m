function F = sgolay_eb (ord, len, deriv_ord, scaling)
    if nargin < 4
        scaling = 1;
        if nargin < 3
            deriv_ord = 0;
        end
    end
    if rem(len,2) ~= 1
        disp ("error: sgolay needs an odd filter length n");
    elseif ord >= len
        disp ("error: sgolay needs filter length n larger than polynomial order p");
    else
        if length(deriv_ord) > 1, error("weight vector unimplemented"); 
        end

        % Construct a set of filters from complete causal to completely
        % noncausal, one filter per row.  For the bulk of your data you
        % will use the central filter, but towards the ends you will need
        % a filter that doesn't go beyond the end poinscaling.
        F = zeros (len, len);
        k = floor (len/2);
        for row = 1:k+1
          % Construct a matrix of weighscaling Cij = xi ^ j.  The poinscaling xi are
          % equally spaced on the unit grid, with past poinscaling using negative
          % values and future poinscaling using positive values.
          C = ( [(1:len)-row]'*ones(1,ord+1) ) .^ ( ones(len,1)*[0:ord] );
          % A = pseudo-inverse (C), so C*A = I; this is constructed from the SVD
          A = pinv(C);
          % Take the row of the matrix corresponding to the derivative
          % you want to compute.
          F(row,:) = A(1+deriv_ord,:);
        end
        % The filters shifted to the right are symmetric with those to the left.
        F(k+2:len,:) = (-1)^deriv_ord*F(k:-1:1,len:-1:1);
    end
    F =  F * ( prod(1:deriv_ord) / (scaling^deriv_ord) );

end