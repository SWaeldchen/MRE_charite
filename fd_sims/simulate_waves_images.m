function [Wave_image, G] = simulate_waves_images(k)

%k=2; % wave number
dx=0.1; % pixel spacing
% define a point source in the center of the image
F=zeros(201,201); 
F(10,10)=1;


si=size(F);
N = numel(F); % number of pixels
% Choose boundary conditions:
%BC= -1; % Dirichlet
% or
%BC=0; % v. Neumann
% or
BC=1i*k*dx; % Sommerfeld
% Assemble the forward Laplacian as a sparse matrix
% from second-order derivatives in 4 directions:
E=ones(si); E(90:110,90:110)=2; E(1,:)=0;
Lap_left=spdiags([-E(:) E(:) ~E(:)*BC],[0 1 0],N,N);
E=ones(si); E(90:110,90:110)=2; E(end,:)=0;
Lap_right=spdiags([-E(:) E(:) ~E(:)*BC],[0 -1 0],N,N);
E=ones(si); E(90:110,90:110)=2; E(:,1)=0;
Lap_up=spdiags([-E(:) E(:) ~E(:)*BC],[0 si(1) 0],N,N);
E=ones(si); E(90:110,90:110)=2; E(:,end)=0;
Lap_down=spdiags([-E(:) E(:) ~E(:)*BC],[0 -si(1) 0],N,N);
Laplacian=(Lap_left+Lap_right+Lap_up+Lap_down)/dx^2;
% The Helmholtz equation Lu+k?2*u = 0
Helmholtz_equ=Laplacian+spdiags(ones(N,1)*k.^2,0,N,N);
% Solve the Helmholtz equation for u and reshape the
% solution vector into an image:
Wave_image=reshape(Helmholtz_equ\F(:),si(1),si(2));
end


