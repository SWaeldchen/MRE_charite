function [K,F] = assemble(p,t)
% K and F for any mesh of triangles: linear 4's
% number of nodes, number of triangles
N=size(p,1);T=size(t,1);
% p lists x,y coordinates of N nodes, t lists triangles by 3 node numbers
K=sparse(N,N); % zero matrix in sparse format: zeros(N) would be "dense"
F=zeros(N,1);
% load vector F to hold integrals of 4's times load f (x, y)
for e=1:T % integration over one triangular element at a time
    nodes=t(e,:);
    % row of t = node numbers of the 3 corners of triangle e
    Pe=[ones(3,1),p(nodes,:)];
    % 3 by 3 matrix with rows=[1 xcorner ycorner]
    Area=abs(det(Pe))/2;
    % area of triangle e = half of parallelogram area
    C=inv(Pe); % columns of C are coeffs in a bx cy to give phi = 1,0,O at nodes
    % now compute 3 by 3 Ke and 3 by 1 Fe for element e
    grad=C(2:3,:);Ke=Area * (grad') *grad; % element matrix from slopes b, c in grad
    Fe=Area/3; % integral of phi over triangle is volume of pyramid: f (x, y) = 1
    % multiply Fe by f at centroid for load f(xly): one- point quadrature!
    % centroid would be mean(p(nodes,:)) = average of 3 node coordinates
    K(nodes,nodes)=K(nodes,nodes) + Ke; % add Ke to 9 entries of global K
    F(nodes)=F(nodes)  + Fe; % add Fe to 3 components of load vector F
end % all T element matrices and vectors now assembled into K and F