function [p,t,b] = squaregrid(m,n) % create grid of N = mn nodes to be listed in p
% generate mesh of T=2(m- l ) ( n - 1) right triangles in unit square
%m = 11; n = 11; % includes boundary nodes, mesh spacing l / ( m - 1) and l/(n - 1)
[x,y]=ndgrid((0: m - 1 ) / ( m - 1),(0: n - 1 ) / ( n - 1)); % matlab forms x and y lists
% N by 2 matrix listing x,y coordinates of all N = mn nodes
p=[x(:),y(:)];
t=[1,2, m + 2; 1 ,m + 2, m + 1]; % 3 node numbers for two triangles in first square
t=kron(t,ones(m - 1, 1))  + kron(ones(size(t)),(0:m - 2)');
% now t lists 3 node numbers of 2(m - 1) triangles in the first mesh row
t=kron(t,ones(n - 1, 1)) +  kron(ones(size(t)),(0:n -2)'*m);
% final t lists 3 node numbers of all triangles in T by 3 matrix
b=[1:m,m + 1:m:m*n,2*m:m:m*n,m*n - m+2:m n -1]; % bottom, left, right, top
% b = numbers of all 2m 2n boundary nodes preparing for U(b)=O