function gradestim4d_example

 [x,y,z] = meshgrid(0:0.05:1,0:0.05:1,0:0.05:1);
 w = sin(2*pi*x); dwdx_exact = 2*pi*cos(2*pi*x);
 [gradw,wstag] = gradestim4d(w,[0.05,0.05,0.05]);
 xs = 0.5*(x(1:end-1,1:end-1,1:end-1)+x(2:end,2:end,2:end)); 
 ys = 0.5*(y(1:end-1,1:end-1,1:end-1)+y(2:end,2:end,2:end));
 zs = 0.5*(z(1:end-1,1:end-1,1:end-1)+z(2:end,2:end,2:end));
 figure(1);clf
 subplot(2,1,1);
 surf(squeeze(xs(:,:,1)),squeeze(ys(:,:,1)),squeeze(gradw(:,:,1,1))); 
 xlabel('x'); ylabel('y'); zlabel('z'); title('numerical');
 subplot(2,1,2);
 surf(squeeze(x(:,:,1)),squeeze(y(:,:,1)),squeeze(dwdx_exact(:,:,1)));
 xlabel('x'); ylabel('y'); zlabel('z'); title('exact');