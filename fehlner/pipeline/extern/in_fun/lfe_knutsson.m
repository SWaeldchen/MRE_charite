function [SIG, para]=lfe_knutsson(w,para)
%
% LFE algorithm from Knutsson et al
%
SIG=[];


if isempty(para)
 
    UD=get(gca,'userdata');
    if isfield(UD,'lfe_k')
        para=UD.lfe_k;
    end
        if isempty(para)
        para=[10 0.1 40 0.2 0.01 1];
        end    

   prompt={'number of filters:','sigma 1:','sigma end:','excitation frequency:','replace amplitude nulls with:','distance per pixel:'};
   def={num2str(para(1)),num2str(para(2)),num2str(para(3)),num2str(para(4)),num2str(para(5)),num2str(para(6))};
   dlgTitle='Input for LFE Knutsson';
   lineNo=1;
   answer=inputdlg(prompt,dlgTitle,lineNo,def);
   
   if isempty(answer)
      return
   end
   
   
   numf=str2num(answer{1});
   f0(1)=str2num(answer{2});
   f0(2)=str2num(answer{3});
   om0=str2num(answer{4});
   tresh=str2num(answer{5});
   dist=str2num(answer{6});
else
    
    numf=para(1);
    f0(1)=para(2);
    f0(2)=para(3);
    om0=para(4);
    tresh=para(5);
    dist=para(6);
    
end

   si=size(w);
   
   Rfz=zeros(si(1),si(2),numf);
   Rfs=zeros(si(1),si(2),numf);
   SIG=zeros(si);
   SIGs=zeros(si);
   SIGz=zeros(si);

if odd(si(1))
fz=[-floor(si(1)/2):floor(si(1)/2)];
halfz=ceil(si(1)/2);
else
fz=[-si(1)/2:si(1)/2-1 ];
halfz=si(1)/2;
end
if odd(si(2))
fs=[-floor(si(2)/2):floor(si(2)/2)];
halfs=ceil(si(2)/2);
else
   fs=[-si(2)/2:si(2)/2-1 ];
   halfs=si(2)/2;
end


freq=fftshift(fft2(w));
 
[Rz, sigma]=lfe_filter_knutsson(fz,f0,numf);
[Rs, sigma]=lfe_filter_knutsson(fs,f0,numf);

n0z=find(fz == 0);
n0s=find(fs == 0);
Rz(:,1:n0z)=0;
Rs(:,1:n0s)=0;

for k=1:numf

  R1=Rz(k,:)'* ones(1,si(2));
  R2=ones(si(1),1) * Rs(k,:);
  Rfz(:,:,k)=R1 .* freq;
  Rfs(:,:,k)=R2 .* freq;
  
end

disp([ 'sigma knutsson: ' num2str(sigma) ]);
figname=get(gcf,'name');

for k=1:numf
set(gcf,'name',['LFE ' num2str(k)]);   
drawnow;
   

Rfz(:,:,k)=ifft2(fftshift(Rfz(:,:,k)));
Rfs(:,:,k)=ifft2(fftshift(Rfs(:,:,k)));



end

Rfz(Rfz == 0)=tresh;
Rfs(Rfs == 0)=tresh;

Q=sqrt(sigma(1:end-1).*sigma(2:end));
Rfz=Rfz(:,:,2:end)./Rfz(:,:,1:end-1);
Rfs=Rfs(:,:,2:end)./Rfs(:,:,1:end-1);



for k=1:numf-1

SIGz=SIGz+Q(k)*Rfz(:,:,k);
SIGs=SIGs+Q(k)*Rfs(:,:,k);

end


SIG=sqrt(si(1)^2./SIGz.^2 + si(2)^2./SIGs.^2);

SIG=real(SIG*(numf-1)*om0);

SIG=SIG*dist;

para=[numf sigma(1) sigma(end) om0 tresh dist];
set(gcf,'name',figname);



