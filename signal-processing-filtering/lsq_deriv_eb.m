function [ u, ux, uy, uz, uxx, uxy, uxz, uyy, uyz, uzz, ud3 ] = computeLeastSquaresDerivatives( u, h, p, ksize, varargin )
% Returns smoothed values and derivatives of 3d scalar field by polynomial interpolation
%
% Input:
%   u       - (3D array) 
%   h       - Grid dimensions
%   p       - Interpolation order (0, 1, 2, or 3)
%   ksize   - Length 3 array, size of box to interpolate over. Current
%             pixel is at center of this box, so each element of ksize must
%             be odd.
%
% Optional Input:
%   special - If true and ksize = 5,5,5 then interpolate over a special
%             spherical type volume
%   mask    - Skips points where mask is 0. For 1-sided fitting at mask
%             edges use function computeLeastSquaresDerivatives_mask
%
% Output:
%   u          - Function values of interpolants.
%   ux, uy, uz - First derivatives of interpolants in x, y, z respectively.
%   uxx, uxy, uxz, uyy, uyz, uzz - Second derivatives of interpolants.
%   ud3 - struct containing 3rd derivatives
%
% Description:
%   Smooths data and derivatives by interpolating over local kernels.
%   Constant extrapolation of data is used at boundaries.
%
% TODO:
%   1) add option for mirroring boundary or extrapolating by higher order
%      or maybe use inward kernel for pixels near boundary ?
%       -- inward kernel is done in computeLeastSquaresDerivatives_mask
%
% Last updated: Sept 2016
% Author: Dan Fovargue

% Get grid info of data
n = size(u);

% Check that its 3D
if length(n)~=3
    error('This function is for 3D data')
end

% Check poly order input
if p<0 || p>3 || (p-floor(p))~=0
    error('p must be an integer in [0,3]')
end

% Check ksize  input. Make sure ksize is a row vector
if isequal(size(ksize),[1 1])
    ksize = [ksize ksize ksize];
elseif isequal(size(ksize),[3 1])
    ksize = ksize';
elseif isequal(size(ksize),[1 3])
else
    error('ksize (stencil) is not the right size - it should either be a scalar or 3x1 or 1x3')
end

% Check that all components of h (stencil) are odd
if ~isequal(mod(ksize,2)==1,[1 1 1])
    error('ksize (stencil) must have all odd components')
end

% Check optional input
if isempty(varargin)
    special = false; % special is false by default
    mask = ones(size(u));
elseif length(varargin)==1
    special = varargin{1};
    mask = ones(size(u));
elseif length(varargin)==2
    special = varargin{1};
    mask = varargin{2};
else
    error('incorrect number of inputs')
end
if special
    if ~isequal(ksize,[5 5 5])
        error('if using special = true then ksize must be 5x5x5')
    end
end

% Allocate arrays for all the output
ux = zeros(n);
uy = zeros(n);
uz = zeros(n);

uxx = zeros(n);
uxy = zeros(n);
uxz = zeros(n);
uyy = zeros(n);
uyz = zeros(n);
uzz = zeros(n);

ud3.uxxx = zeros(n);
ud3.uxxy = zeros(n);
ud3.uxxz = zeros(n);
ud3.uxyy = zeros(n);
ud3.uxyz = zeros(n);
ud3.uxzz = zeros(n);
ud3.uyyy = zeros(n);
ud3.uyyz = zeros(n);
ud3.uyzz = zeros(n);
ud3.uzzz = zeros(n);

% Get size of each stencil direction in one direction from midpoint (e.g. 3->1 5->2)
ks = floor(ksize/2);

% Add extra rows/columns/slices to data
% This is so the boundary pixels can use the same kernel
uu = zeros(n+2*ks);
uu( 1+ks(1):end-ks(1) , 1+ks(2):end-ks(2) , 1+ks(3):end-ks(3) ) = u;

% Fill those extra pixels with repeated values
for i=1:ks(1)
    uu(i,:,:) = uu(ks(1)+1,:,:);
    uu(end-i+1,:,:) = uu(end-ks(1),:,:);
end
for i=1:ks(2)
    uu(:,i,:) = uu(:,ks(2)+1,:);
    uu(:,end-i+1,:) = uu(:,end-ks(2),:);
end
for i=1:ks(3)
    uu(:,:,i) = uu(:,:,ks(3)+1);
    uu(:,:,end-i+1) = uu(:,:,end-ks(3));
end

% Assume all points will contribute
ktf = ones(ksize);

% If special shape this update ktf non-cube shape (ksize needs to be 5x5x5)
if special
    ktf = getSpecialKTF(ksize,special);
end

ktfv = reshape(ktf,[],1);

% Get Vandermonde matrix
J = createVandermondeMatrix3D(p,ksize,ktf);

% Solve to get matrix to apply to each data subset
C = (J'*J) \ (J');

% Loop over data
for i=1:n(1)
    for j=1:n(2)
        for k=1:n(3)
            
            if ~mask(i,j,k)
                continue;
            end
            
            ii = i+ks(1);
            jj = j+ks(2);
            kk = k+ks(3);
            
            % Extract relevant data
            uv = reshape(uu((ii-ks(1):ii+ks(1)), ...
                            (jj-ks(2):jj+ks(2)), ...
                            (kk-ks(3):kk+ks(3))), [] , 1);
            
            uv = uv(ktfv==1);
            
            lp = C * uv;
            
            u(i,j,k) = lp(1);
            
            if p>=1
                ux(i,j,k) = lp(2);
                uy(i,j,k) = lp(3);
                uz(i,j,k) = lp(4);
            end
            
            if p>=2
                uxx(i,j,k) = lp(5);
                uxy(i,j,k) = lp(6);
                uxz(i,j,k) = lp(7);
                uyy(i,j,k) = lp(8);
                uyz(i,j,k) = lp(9);
                uzz(i,j,k) = lp(10);
            end
            
            if p>=3
                ud3.uxxx(i,j,k) = lp(11);
                ud3.uxxy(i,j,k) = lp(12);
                ud3.uxxz(i,j,k) = lp(13);
                ud3.uxyy(i,j,k) = lp(14);
                ud3.uxyz(i,j,k) = lp(15);
                ud3.uxzz(i,j,k) = lp(16);
                ud3.uyyy(i,j,k) = lp(17);
                ud3.uyyz(i,j,k) = lp(18);
                ud3.uyzz(i,j,k) = lp(19);
                ud3.uzzz(i,j,k) = lp(20);
            end
            
        end
    end
end

% Scale by grid size
ux = ux ./ h(1);
uy = uy ./ h(2);
uz = uz ./ h(3);

uxx = uxx ./ (h(1)*h(1));
uxy = uxy ./ (h(1)*h(2));
uxz = uxz ./ (h(1)*h(3));
uyy = uyy ./ (h(2)*h(2));
uyz = uyz ./ (h(2)*h(3));
uzz = uzz ./ (h(3)*h(3));

uxx = uxx * 2;
uyy = uyy * 2;
uzz = uzz * 2;

ud3.uxxx = ud3.uxxx ./ (h(1)*h(1)*h(1));
ud3.uxxy = ud3.uxxy ./ (h(1)*h(1)*h(2));
ud3.uxxz = ud3.uxxz ./ (h(1)*h(1)*h(3));
ud3.uxyy = ud3.uxyy ./ (h(1)*h(2)*h(2));
ud3.uxyz = ud3.uxyz ./ (h(1)*h(2)*h(3));
ud3.uxzz = ud3.uxzz ./ (h(1)*h(3)*h(3));
ud3.uyyy = ud3.uyyy ./ (h(2)*h(2)*h(2));
ud3.uyyz = ud3.uyyz ./ (h(2)*h(2)*h(3));
ud3.uyzz = ud3.uyzz ./ (h(2)*h(3)*h(3));
ud3.uzzz = ud3.uzzz ./ (h(3)*h(3)*h(3));

ud3.uxxx = ud3.uxxx * 3 * 2;
ud3.uyyy = ud3.uyyy * 3 * 2;
ud3.uzzz = ud3.uzzz * 3 * 2;

ud3.uxxy = ud3.uxxy * 2;
ud3.uxxz = ud3.uxxz * 2;
ud3.uxyy = ud3.uxyy * 2;
ud3.uxzz = ud3.uxzz * 2;
ud3.uyyz = ud3.uyyz * 2;
ud3.uyzz = ud3.uyzz * 2;

end


function ktf = getSpecialKTF(ksize,type)

if type==1
    
    ktf = zeros(ksize);
    ktf(2:4,2:4,2:4) = 1;
    ktf(3,3,1) = 1;
    ktf(3,4,1) = 1;
    ktf(4,3,1) = 1;
    ktf(3,2,1) = 1;
    ktf(2,3,1) = 1;

    ktf(3,3,5) = 1;
    ktf(4,3,5) = 1;
    ktf(3,4,5) = 1;
    ktf(2,3,5) = 1;
    ktf(3,2,5) = 1;

    ktf(3,1,3) = 1;
    ktf(4,1,3) = 1;
    ktf(3,1,4) = 1;
    ktf(2,1,3) = 1;
    ktf(3,1,4) = 1;

    ktf(3,5,3) = 1;
    ktf(4,5,3) = 1;
    ktf(3,5,4) = 1;
    ktf(2,5,3) = 1;
    ktf(3,5,2) = 1;

    ktf(1,3,3) = 1;
    ktf(1,4,3) = 1;
    ktf(1,3,4) = 1;
    ktf(1,2,3) = 1;
    ktf(1,3,2) = 1;

    ktf(5,3,3) = 1;
    ktf(5,4,3) = 1;
    ktf(5,3,4) = 1;
    ktf(5,2,3) = 1;
    ktf(5,3,2) = 1;

elseif type==2
    
    ktf = ones(ksize);
    ktf(1,1,1) = 0;
    ktf(5,1,1) = 0;
    ktf(1,5,1) = 0;
    ktf(5,5,1) = 0;
    ktf(1,1,5) = 0;
    ktf(5,1,5) = 0;
    ktf(1,5,5) = 0;
    ktf(5,5,5) = 0;
    
end

end

