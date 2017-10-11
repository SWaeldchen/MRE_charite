function E = strain_tensor(U, spacing, xyz_order, kern_ord)

% create FD gradient functions
if nargin < 3
    xyz_order = [1 2 3];
end
if nargin < 4
    kern = [0.5 0 -0.5];
else
    switch kern_ord
        case 1
             kern = [1 -1];
        case 2
            kern = [0.5 0 -0.5];
        case 3
            kern = [1/12 -2/3 0 2/3 -1/12];
    end
end
x_grad_kern = kern  / spacing(1);
y_grad_kern = kern'  / spacing(2);
z_grad_kern = zeros(1,1,numel(kern)); z_grad_kern(:) = kern  / spacing(3);

xgrad = @(v) convn(v, x_grad_kern, 'same');
ygrad = @(v) convn(v, y_grad_kern, 'same');
zgrad = @(v) convn(v, z_grad_kern, 'same');

U_x = double(U(:,:,:,xyz_order(1),n)); %nifti complex format is single
U_y = double(U(:,:,:,xyz_order(2),n));
U_z = double(U(:,:,:,xyz_order(3),n));

x_x = xgrad(U_x); x_y = ygrad(U_x); x_z = zgrad(U_x);
y_x = xgrad(U_y); y_y = ygrad(U_y); y_z = zgrad(U_y);
z_x = xgrad(U_z); z_y = ygrad(U_z); z_z = zgrad(U_z);

E = {   { x_x         }  {(x_y + y_x)/2}  {(x_z + z_x)/2}    ;   ...
        {(y_x + x_y)/2}  { y_y         }  {(y_z + z_y)/2}    ;   ...
        {(z_x + x_z)/2}  {(z_y + y_z)/2}  {z_z          }     };