function [Wave_image] = fd_sim_2d(k, map)

%k=2; % wave number
dx=0.1; % pixel spacing
% define a point source in the corner of the image
sz = size(map);
mids = round(sz / 2);
F=zeros(sz); 
F(mids(1), mids(2))=1;
N = numel(F); % number of pixels
% Choose boundary conditions:
%BC= -1; % Dirichlet
% or
%BC=0; % v. Neumann
% or
BC=1i*k*dx; % Sommerfeld
% Assemble the forward Laplacian as a sparse matrix
% from second-order derivatives in 4 directions:
e_maps = get_E_maps(map);
Lap_left=spdiags([-e_maps{1}(:) e_maps{1}(:) ~e_maps{1}(:)*BC],[0 1 0],N,N);
Lap_right=spdiags([-e_maps{2}(:) e_maps{2}(:) ~e_maps{2}(:)*BC],[0 -1 0],N,N);
Lap_up=spdiags([-e_maps{3}(:) e_maps{3}(:) ~e_maps{3}(:)*BC],[0 sz(1) 0],N,N);
Lap_down=spdiags([-e_maps{4}(:) e_maps{4}(:) ~e_maps{4}(:)*BC],[0 -sz(1) 0],N,N);
Laplacian=(Lap_left+Lap_right+Lap_up+Lap_down)/dx^2;
% The Helmholtz equation Lu+k?2*u = 0
Helmholtz_equ=Laplacian+spdiags(ones(N,1)*k.^2,0,N,N);
% Solve the Helmholtz equation for u and reshape the
% solution vector into an image:
sol = Helmholtz_equ\F(:);
Wave_image = reshape(sol,sz(1),sz(2));
end

function e_maps = get_E_maps(map)

e_maps = {map, map, map, map};
e_maps{1}(1,:) = 0;
e_maps{2}(end,:) = 0;
e_maps{3}(:,1) = 0;
e_maps{4}(:,end) = 0;

end
