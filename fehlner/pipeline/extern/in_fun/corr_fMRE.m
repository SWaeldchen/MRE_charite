function C=corr_fMRE(W)
%
% C=corr_fMRE(W)
%

si=size(W);
if length(si) == 4
    W=reshape(W,si(1),si(2),si(3)*si(4));
end

vec=ones(1,size(W,3))*0.5;
vec(2:2:end)=-0.5;


for k1=1:size(W,1) 
    for k2=1:size(W,2) 
            C(k1,k2)=sum(squeeze(W(k1,k2,:)).*vec')./sum(squeeze(W(k1,k2,:)));
    end
end