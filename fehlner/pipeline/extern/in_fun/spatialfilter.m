function U=spatialfilter(U,K,bw,obj,direct)
%
% U=spatialfilter(U,K,bw,obj,direct)
% U: Wellenbild
% K: Position des Filters im k-Raum
% bw: bandwidth
% obj: Ausdehnung des Objektes
% direct: Richtung (x,y)

if strcmp(direct,'x')
    U=U';
end

si=size(U,2);
dw=obj/si;
k=linspace(-0.5/dw,0.5/dw,si);
dw2=k(2)-k(1);
k=k-dw2/2;
k2=k;

switch direct
    case 'x'
        k(k <= 0)=1e-10;
        U=U.';
    case 'y'
        k(k <= 0)=1e-10;
        
   otherwise
        error('wrong direction!')
end    


FU=fftshift(fft(U,[],2),2);
r=exp(-(log(k/K)).^2*bw);

figure
plot(k2,r)
axis tight
grid on

R=ones(size(U,1),1)*r;

FU=FU.*R;
U=ifft(FU,[],2);
U(:,2:2:end)=-U(:,2:2:end);
%U=real(U);


if strcmp(direct,'x')
    U=U.';
end