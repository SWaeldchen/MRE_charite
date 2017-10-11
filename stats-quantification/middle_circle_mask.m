function m = middle_circle_mask(u)

u_vol = u(:,:,:,1);
u_mc = middle_circle(u_vol);
u_mc(~isnan(u_mc)) = 1;
u_mc(isnan(u_mc)) = 0;
m = logical(u_mc);