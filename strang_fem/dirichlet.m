function [Kb, Fb] = dirichlet(K,F,b,p) % assembled K was singular! K * ones(N, l ) = O
% Implement Dirichlet boundary conditions U(b)=O a t nodes in list b
K(b,:)=0; 
K(:,b)=0; 
F(b)= 0; % put zeros in boundary rows/columns of K and F
K(b,b)=speye(length(b),length(b));
% put I into boundary submatrix of K
Kb=K; Fb=F; % Stiffness matrix Kb (sparse format) and load vector F b
% Solving for the vector U will produce U(b)=O at boundary nodes
U=Kb\Fb; % The FEM approximation is U141 ++ UN$N
% Plot the FEM approximation U(x,y) with values Ul to UN at the nodes
trisurf(t,p(:,1),p(:,2),0 * p(:,1),U,'edgecolor','k','facecolor','interp');
view(2),axis equal,colorbar