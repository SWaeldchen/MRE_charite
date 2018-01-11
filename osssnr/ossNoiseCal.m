function [ossnoise]=ossNoiseCal(displacement, spacing)
sz=size(displacement);
for ff=1:sz(5)    
    
    for zz=1:sz(3)
        
        dudx(:,:,zz)=transpose([diff(transpose(displacement(:,:,zz,2,ff)))/spacing(1); zeros(1, sz(1),1,1,1)]);
        dvdx(:,:,zz)=transpose([diff(transpose(displacement(:,:,zz,1,ff)))/spacing(1); zeros(1, sz(1),1,1,1)]);
        dwdx(:,:,zz)=transpose([diff(transpose(displacement(:,:,zz,3,ff)))/spacing(1); zeros(1, sz(1),1,1,1)]);
        
        dudy(:,:,zz)=[diff(displacement(:,:,zz,2,ff))/spacing(2); zeros(1, sz(2),1,1,1)];
        dvdy(:,:,zz)=[diff(displacement(:,:,zz,1,ff))/spacing(2); zeros(1, sz(2),1,1,1)];
        dwdy(:,:,zz)=[diff(displacement(:,:,zz,3,ff))/spacing(2); zeros(1, sz(2),1,1,1)];       
        
    end    
    
    dudz(:,:,:)=reshape(transpose([diff(transpose(reshape(displacement(:,:,:,2,ff),sz(1)*sz(2),sz(3),1,1)))/spacing(3); zeros(1, sz(1)*sz(2),1,1,1)]),sz(1),sz(2),sz(3),1,1,1);
    dvdz(:,:,:)=reshape(transpose([diff(transpose(reshape(displacement(:,:,:,1,ff),sz(1)*sz(2),sz(3),1,1)))/spacing(3); zeros(1, sz(1)*sz(2),1,1,1)]),sz(1),sz(2),sz(3),1,1,1);
    dwdz(:,:,:)=reshape(transpose([diff(transpose(reshape(displacement(:,:,:,3,ff),sz(1)*sz(2),sz(3),1,1)))/spacing(3); zeros(1, sz(1)*sz(2),1,1,1)]),sz(1),sz(2),sz(3),1,1,1);
    
    
    exx=dudx; exy=0.5*(dudy+dvdx); exz=0.5*(dudz+dwdx); eyx=exy; eyy=dvdy; eyz=0.5*(dvdz+dwdy); ezx=exz; ezy=eyz; ezz=dwdz;
    es=(2/3)*sqrt((exx-eyy).^2+(exx-ezz).^2+(eyy-ezz).^2+6*(exy.^2+exz.^2+eyz.^2));
    ossnoise(:,:,:,ff)=es(:,:,:);
end
end