function gradF = wgrad3d(F,d,order)
% 3D-Weighted Regression method for gradient estimation in cartesian grids
%
% gradF = wgrad3d(F,[dx,dy,dz])
% Gradient estimation at nodes in cartesian grids
% 
% Note that size(gradF) = [size(F)-[1,1,1],3].
%
% Example:
% [x,y,z] = meshgrid(0:0.05:1,0:0.05:1,0:0.05:1);
% w = sin(2*pi*x); dwdx_exact = 2*pi*cos(2*pi*x);
% gradw = wgrad3d(w,[0.05,0.05,0.05]);
% figure(1); clf;
% subplot(2,1,1);
% surf(squeeze(x(2:end-1,2:end-1,3)),...
%      squeeze(y(2:end-1,2:end-1,3)),...
%      squeeze(z(2:end-1,2:end-1,3)),...
%      squeeze(gradw(:,:,3,1)));
% xlabel('x'); ylabel('y'); zlabel('z'); title('numerical');
% subplot(2,1,2);
% surf(squeeze(x(2:end-1,2:end-1,3)),...
%      squeeze(y(2:end-1,2:end-1,3)),...
%      squeeze(z(2:end-1,2:end-1,3)),...
%      squeeze(dwdx_exact(2:end-1,2:end-1,3)));
% xlabel('x'); ylabel('y'); zlabel('z'); title('exact');
%
% Following: 
% 'Gradient estimation in volume data using 4D Linear Regression'
% Neumann et al., Comput.Graph Forum, vol.19, no.3, pp.351-358 (2000)
%
% J.Mura (2017).

if nargin<3
  order = [2,1,3];
end

dx=d(order(1)); dy=d(order(2)); dz=d(order(3));
[nx,ny,nz] = size(F);

% initializing matrices
gradF = zeros([size(F)-[2,2,2],3]);

% Local connectivity matrix (26 nodes around the center)
C0 = [1,0;
  1,1;
  0,1;
  -1,1];
C = [[C0;-C0],zeros(8,1);[C0;-C0],ones(8,1);...
  [C0;-C0],-ones(8,1);0,0,1;0,0,-1];

Dr = repmat([dx,dy,dz],26,1);

% Relative coordinates
X = Dr + C; 

% Relative distance
D = Dr.*C;
dist2 = sum(D.*D,2);
W2 = diag(1./(dist2.^2)); % weighting matrix

A = X.'*W2*X;


%% slow form
for I = 2:nx-1
  for J = 2:ny-1
    for K = 2:nz-1
      Ind = repmat([I,J,K],26,1) + C;
      ii = sub2ind(size(F),Ind(:,1),Ind(:,2),Ind(:,3));
      fm = F(ii);
      b = fm-F(I,J,K);
      
      x = A\(X.'*W2*b);

      gradF(I-1,J-1,K-1,1) = x(order(1));
      gradF(I-1,J-1,K-1,2) = x(order(2));
      gradF(I-1,J-1,K-1,3) = x(order(3));
    end
  end
end

return

return;