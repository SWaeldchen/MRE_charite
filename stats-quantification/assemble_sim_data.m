cd(getenv('MRE'));
cd sims/Symmetric_boundary_conditions/
cd 50Hz/1_00Pas
load('x-direction.mat');
f50_x = cat(4, path_1, path_2, path_3, path_4, path_5); 
f50_x = permute(f50_x, [1 2 4 3]);
load('y-direction.mat');
f50_y = cat(4, path_1, path_2, path_3, path_4, path_5);
f50_y = permute(f50_y, [1 2 4 3]);
load('z-direction.mat');
f50_z = cat(4, path_1, path_2, path_3, path_4, path_5);
f50_z = permute(f50_z, [1 2 4 3]);
cd ../../60Hz/1_00Pas
load('x-direction.mat');
f60_x = cat(4, path_1, path_2, path_3, path_4, path_5); 
f60_x = permute(f60_x, [1 2 4 3]);
load('y-direction.mat');
f60_y = cat(4, path_1, path_2, path_3, path_4, path_5);
f60_y = permute(f60_y, [1 2 4 3]);
load('z-direction.mat');
f60_z = cat(4, path_1, path_2, path_3, path_4, path_5);
f60_z = permute(f60_z, [1 2 4 3]);
cd ../../70Hz/1_00Pas
load('x-direction.mat');
f70_x = cat(4, path_1, path_2, path_3, path_4, path_5); 
f70_x = permute(f70_x, [1 2 4 3]);
load('y-direction.mat');
f70_y = cat(4, path_1, path_2, path_3, path_4, path_5);
f70_y = permute(f70_y, [1 2 4 3]);
load('z-direction.mat');
f70_z = cat(4, path_1, path_2, path_3, path_4, path_5);
f70_z = permute(f70_z, [1 2 4 3]);
cd ../../80Hz/1_00Pas
load('x-direction.mat');
f80_x = cat(4, path_1, path_2, path_3, path_4, path_5); 
f80_x = permute(f80_x, [1 2 4 3]);
load('y-direction.mat');
f80_y = cat(4, path_1, path_2, path_3, path_4, path_5);
f80_y = permute(f80_y, [1 2 4 3]);
load('z-direction.mat');
f80_z = cat(4, path_1, path_2, path_3, path_4, path_5);
f80_z = permute(f80_z, [1 2 4 3]);
f50 = cat(5, f50_x, f50_y, f50_z);
f60 = cat(5, f60_x, f60_y, f60_z);
f70 = cat(5, f70_x, f70_y, f70_z);
f80 = cat(5, f80_x, f80_y, f80_z);
U = cat(6, f50, f60, f70, f80);
U = 2*pi*(U - min(U(:))) / (max(U(:)) - min(U(:)));
U2 = cat(3, U, shiftdim(flipud(shiftdim(U,2)),4), U);
U2 = U2(:,:,[1:5 7:10 12:15],:,:,:);
U2 = U2 + rand(size(U2))*2*pi*0.01;
b2 = make_bulk(size(U2));
U2_bulk = U2;
U2_bulk(:,:,:,:,3,:) = U2_bulk(:,:,:,:,3,:)+ b2;