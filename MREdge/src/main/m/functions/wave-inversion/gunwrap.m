function [wu wx]=gunwrap(w)
%
% [wu wx]=gunwrap(w)
% in-plane Laplacian unwrap
% w max 7D
% 16.9.2014 is

si=size(w);
si=[si 1 1 1 1 1];

w=w-min(w(:));
w=w/max(w(:))*2*pi;

E=ones(si(1)*si(2),1);
d=spdiags([E E -4*E E E],[-si(1) -1:1 si(1)],si(1)*si(2),si(1)*si(2));


PHI =exp(1i*w);
PHIi=exp(-1i*w);

wx=zeros(si(1)*si(2),si(3),si(4),si(5),si(6),si(7));
wu=zeros(si(1)*si(2),si(3),si(4),si(5),si(6),si(7));

for kv=1:si(7)
    for kf=1:si(6)
        for kc=1:si(5)
            fprintf('f%dc%d',[kf kc])
            for kt=1:si(4)
                for ks=1:si(3)
    
                tmpi=PHIi(:,:,ks,kt,kc,kf,kv);
                tmp=PHI(:,:,ks,kt,kc,kf,kv);    
                tmp=d*tmp(:);
    
                wx(:,ks,kt,kc,kf,kv)=imag(tmp(:).*tmpi(:));
                wu(:,ks,kt,kc,kf,kv)=d\wx(:,ks,kt,kc,kf,kv);
                
                end
            end
        end
    end
end

wx=reshape(wx,si);
wu=reshape(wu,si);

     
