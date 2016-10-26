function ret = smooth3_eb(data, filt, sz, arg)



if nargin==1      %smooth3(data)
  filt = 'b';
  sz = 3;
  arg = .65;
elseif nargin==2  %smooth3(data, filter)
  sz = 3;
  arg = .65;
elseif nargin==3  %smooth3(data, filter, sz)
  arg = .65;
elseif nargin>4 || nargin==0
  error('wrong number of inputs'); 
end

if ndims(data)~=3
  error('data not 3d');
end

if length(sz)==1
  sz = [sz sz sz];
elseif numel(sz)~=3
  error('invalid size input')
end

sz = sz(:)';

padSize = (sz-1)/2;

if ~isequal(padSize, floor(padSize)) || any(padSize<0)
  error('invalid size values');
end

if filt(1)=='g' %gaussian
  smooth = gaussian3(sz,arg);
elseif filt(1)=='b' %box
  smooth = ones(sz)/prod(sz);
else
  error('unknown filter');
end

ret=convn(padreplicate(data,padSize),smooth, 'valid');


function h = gaussian3(P1, P2)
%3D Gaussian lowpass filter
%
%   H = gausian3(N,SIGMA) returns a rotationally
%   symmetric 3D Gaussian lowpass filter with standard deviation
%   SIGMA (in pixels). N is a 1-by-3 vector specifying the number
%   of rows, columns, pages in H. (N can also be a scalar, in 
%   which case H is NxNxN.) If you do not specify the parameters,
%   the default values of [3 3 3] for N and 0.65 for
%   SIGMA.


if nargin>0,
  if ~(all(size(P1)==[1 1]) || all(size(P1)==[1 3])),
     error('invalid first input');
  end
  if length(P1)==1, siz = [P1 P1 P1]; else siz = P1; end
end

if nargin<1, siz = [3 3 3]; end
if nargin<2, std = .65; else std = P2; end
[x,y,z] = meshgrid(-(siz(2)-1)/2:(siz(2)-1)/2, -(siz(1)-1)/2:(siz(1)-1)/2, -(siz(3)-1)/2:(siz(3)-1)/2);
h = exp(-(x.*x + y.*y + z.*z)/(2*std*std));
h = h/sum(h(:));


function b=padreplicate(a, padSize)
%Pad an array by replicating values.
numDims = length(padSize);
idx = cell(numDims,1);
for k = 1:numDims
  M = size(a,k);
  onesVector = ones(1,padSize(k));
  idx{k} = [onesVector 1:M M*onesVector];
end

b = a(idx{:});


