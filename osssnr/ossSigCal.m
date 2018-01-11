function [osssignal]= ossSigCal(displacement, spacing)
sz=size(displacement);
for ff=1:sz(6)
    for zz=1:sz(3)
        for tt=1:sz(4)
            dudx(:,:,zz,tt)=transpose([diff(transpose(displacement(:,:,zz,tt,2,ff)))/spacing(1); zeros(1, sz(1), 1,1,1,1)]);
            dvdx(:,:,zz,tt)=transpose([diff(transpose(displacement(:,:,zz,tt,1,ff)))/spacing(1); zeros(1, sz(1), 1,1,1,1)]);
            dwdx(:,:,zz,tt)=transpose([diff(transpose(displacement(:,:,zz,tt,3,ff)))/spacing(1); zeros(1, sz(1), 1,1,1,1)]);
            
            dudy(:,:,zz,tt)=[diff(displacement(:,:,zz,tt,2,ff))/spacing(2); zeros(1, sz(2),1,1,1,1)];
            dvdy(:,:,zz,tt)=[diff(displacement(:,:,zz,tt,1,ff))/spacing(2); zeros(1, sz(2),1,1,1,1)];
            dwdy(:,:,zz,tt)=[diff(displacement(:,:,zz,tt,3,ff))/spacing(2); zeros(1, sz(2),1,1,1,1)];
            
        end
    end
    
    for tt=1:sz(4)
        dudz(:,:,:,tt)=reshape(transpose([diff(transpose(reshape(displacement(:,:,:,tt,2,ff),sz(1)*sz(2),sz(3),1,1,1)))/spacing(3); zeros(1, sz(1)*sz(2),1,1,1)]),sz(1),sz(2),sz(3),1,1,1);
        dvdz(:,:,:,tt)=reshape(transpose([diff(transpose(reshape(displacement(:,:,:,tt,1,ff),sz(1)*sz(2),sz(3),1,1,1)))/spacing(3); zeros(1, sz(1)*sz(2),1,1,1)]),sz(1),sz(2),sz(3),1,1,1);
        dwdz(:,:,:,tt)=reshape(transpose([diff(transpose(reshape(displacement(:,:,:,tt,3,ff),sz(1)*sz(2),sz(3),1,1,1)))/spacing(3); zeros(1, sz(1)*sz(2),1,1,1)]),sz(1),sz(2),sz(3),1,1,1);
    end
    
    exx=dudx; exy=0.5*(dudy+dvdx); exz=0.5*(dudz+dwdx); eyx=exy; eyy=dvdy; eyz=0.5*(dvdz+dwdy); ezx=exz; ezy=eyz; ezz=dwdz;
    es=(2/3)*sqrt((exx-eyy).^2+(exx-ezz).^2+(eyy-ezz).^2+6*(exy.^2+exz.^2+eyz.^2));
    oss(:,:,:,:,ff)=es(:,:,:,:);
    osssignal(:,:,:,ff)=mean(es,4);
end

end