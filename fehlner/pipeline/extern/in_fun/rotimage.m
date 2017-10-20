function [Uxrot, Uyrot]=rotimage(Ux,Uy,ang)
%
% Urot=rotimage(Ux,Uy,ang)
%

    th=pi/180*ang;
    if size(ang) == [2 2]
        disp('take ang as rotation matrix')
        A=ang;
    else
        A=[cos(th) sin(th); -sin(th) cos(th)];
    end

    dim=size(Ux);
    
    tmp1=reshape(Ux,1,prod(dim));
    tmp2=reshape(Uy,1,prod(dim));
    
    v=zeros(2,prod(dim));
    
    for k=1:prod(dim) 
  
        v_tmp=[tmp1(k); tmp2(k)]; 
        v(:,k)=A*v_tmp;
        %v(:,k)=v(:,k)/norm(v(:,k));
    end

    Uxrot=reshape(v(1,:),dim);    
    Uyrot=reshape(v(2,:),dim);



