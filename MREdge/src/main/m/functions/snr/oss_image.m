function oss_img = oss_image(U, spacing, xyz_order, kern_ord)

%U = mir(U);
% set constantsxyz
sz = size(U);
if numel(sz) < 6
    nfreqs = 1;
else
    nfreqs = sz(6);
end

% create FD gradient functions
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
if nargin < 3
    xyz_order = [1 2 3];
end
if nargin < 2
    spacing = [1 1 1];
end
x_grad_kern = kern  / spacing(1);
y_grad_kern = kern'  / spacing(2);
z_grad_kern = zeros(1,1,numel(kern)); z_grad_kern(:) = kern  / spacing(3);

xgrad = @(v) convn(v, x_grad_kern, 'same');
ygrad = @(v) convn(v, y_grad_kern, 'same');
zgrad = @(v) convn(v, z_grad_kern, 'same');

% stack for n frequencies
for n = 1:nfreqs
          
    U_x = double(U(:,:,:,xyz_order(1),n)); %nifti complex format is single
    U_y = double(U(:,:,:,xyz_order(2),n));
    U_z = double(U(:,:,:,xyz_order(3),n));
    
    x_x = xgrad(U_x); x_y = ygrad(U_x); x_z = zgrad(U_x);
    y_x = xgrad(U_y); y_y = ygrad(U_y); y_z = zgrad(U_y);
    z_x = xgrad(U_z); z_y = ygrad(U_z); z_z = zgrad(U_z);
 
    
    E = {   { x_x         }  {(x_y + y_x)/2}  {(x_z + z_x)/2}    ;   ...
            {(y_x + x_y)/2}  { y_y         }  {(y_z + z_y)/2}    ;   ...
            {(z_x + x_z)/2}  {(z_y + y_z)/2}  {z_z          }     };
        
    oss_img(:,:,:,n)=2/3*sqrt((cell2mat(E{1,1})-cell2mat(E{2,2})).^2+(cell2mat(E{1,1})-cell2mat(E{3,3})).^2+(cell2mat(E{2,2})-cell2mat(E{3,3})).^2+6*(cell2mat(E{1,2}).^2+cell2mat(E{1,3}).^2+cell2mat(E{2,3}).^2));            
end
end