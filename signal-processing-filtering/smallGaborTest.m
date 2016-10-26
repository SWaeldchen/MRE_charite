
n = [-pi/2; 0 ; pi/2]
m = [-pi/2; 0; pi/2]
for i=1:3
    for j=1:3
        filt = javaMethod('getGaborFilter', GaborFilter, 3, [3 3], m(i), n(j), 0, 0);
        openImage(filt(:,:,:,1));
        openImage(filt(:,:,:,2));
        openImage(filt(:,:,:,3));
    end
end