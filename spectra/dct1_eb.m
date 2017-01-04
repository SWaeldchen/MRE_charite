function b=dct_eb(a,n)
%DCT  Discrete cosine transform.
%
%   Y = DCT(X) returns the discrete cosine transform of X.
%   The vector Y is the same size as X and contains the
%   discrete cosine transform coefficients.
%
%   Y = DCT(X,N) pads or truncates the vector X to length N 
%   before transforming.
%
%   If X is a matrix, the DCT operation is applied to each
%   column.  This transform can be inverted using IDCT.
%
%   % Example:
%   %   Find how many DCT coefficients represent 99% of the energy 
%   %   in a sequence.
%
%   x = (1:100) + 50*cos((1:100)*2*pi/40);  % Input Signal 
%   X = dct(x);                             % Discrete cosine transform
%   [XX,ind] = sort(abs(X)); ind = fliplr(ind);
%   num_coeff = 1;
%   while (norm([X(ind(1:num_coeff)) zeros(1,100-num_coeff)])/norm(X)<.99)
%       num_coeff = num_coeff + 1;
%   end;
%   num_coeff                  
%
%   See also FFT, IFFT, IDCT.

%   Author(s): C. Thompson, 2-12-93
%              S. Eddins, 10-26-94, revised
%   Copyright 1988-2013 The MathWorks, Inc.

%   References: 
%   1) A. K. Jain, "Fundamentals of Digital Image
%      Processing", pp. 150-153.
%   2) Wallace, "The JPEG Still Picture Compression Standard",
%      Communications of the ACM, April 1991.


% checks if X is a valid numeric data input

ww = (exp(-1i*(0:n-1)*pi/(2*n))/sqrt(2*n)).';
ww(1) = ww(1) / sqrt(2);

if rem(n,2)==1 || ~isreal(a), % odd case
  % Form intermediate even-symmetric matrix
  y = zeros(2*n,m,class(a));
  y(1:n,:) = aa;
  y(n+1:2*n,:) = flipud(aa);
  
  % Compute the FFT and keep the appropriate portion:
  yy = fft(y);  
  yy = yy(1:n,:);

else % even case
  % Re-order the elements of the columns of x
  y = [ aa(1:2:n,:); aa(n:-2:2,:) ];
  yy = fft(y);  
  ww = 2*ww;  % Double the weights for even-length case  
end

% Multiply FFT by weights:
b = ww(:,ones(1,m)) .* yy;
