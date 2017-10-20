function [SIG, para]=lfe_gauss(w, para)
%
% calcs lfe gaussian with sigma variation
%


if nargin < 1
     im=findobj(gca,'type','image','visible','on');
     w=get(im,'Cdata');
 end
 
 si=size(w);

 if isempty(para)
 
        UD=get(gca,'userdata');
        if isfield(UD,'lfe_g')
        para=UD.lfe_g;
        end
        
        if isempty(para)
        para=[10 0.5 0.6 0.2 0.01 1 0];
        end    

   prompt={'number of filters:','sigma 1:','fac:','excitation frequency:','replace amplitude nulls with:',...
           'distance per pixel:','flag for complex LFE (1) or real LFE (0)'};
   def={num2str(para(1)),num2str(para(2)),num2str(para(3)),num2str(para(4)),num2str(para(5)), num2str(para(6)),num2str(para(7))};
   dlgTitle='Input for LFE Gauss';
   lineNo=1;
   answer=inputdlg(prompt,dlgTitle,lineNo,def);
   
   if isempty(answer)
      return
   end
   
   numf=str2num(answer{1});
   sigma=str2num(answer{2});
   fac=str2num(answer{3});
   om0=str2num(answer{4});
   tresh=str2num(answer{5});
   dist=str2num(answer{6});
   flag=str2num(answer{7});
   
else
    
    numf=para(1);
    sigma=para(2);
    fac=para(3);
    om0=para(4);
    tresh=para(5);
    dist=para(6);
    flag=para(7);
end

%%%%%%% make sigma%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  for k=2:numf
      
      sigma(k)=sqrt(1/(1/sigma(k-1)^2 - fac));
      
  end
  
  disp([ 'sigma gauss: ' num2str(sigma) ]);
  %%%%%%%%%%%%%%%%%%Calc starts%%%%%%%%%%%%%%%%%%%%%%
   
   
   Rf=zeros(si(1),si(2),numf);
   SIG=zeros(si);

   if ~odd(si(1))
       si(1)=si(1)+1;
   end
   if ~odd(si(2))
       si(2)=si(2)+1;
   end
   
    fz=linspace(-si(1)/2,si(1)/2,si(1));
    fs=linspace(-si(2)/2,si(2)/2,si(2));

   freq=fftshift(fft2(w,si(1),si(2)));
 %  [freq, BW]=fft2roi(w); 
   
   D=ones(si);
   
   if flag
   D(:,1:round(si(2)/2))=0;
   D(1:round(si(1)/2),:)=0;
   end

   for k=1:numf
       
   Rz(k,:)=exp(-0.5*fz.^2/(sigma(k)*si(1))^2);
   Rs(k,:)=exp(-0.5*fs.^2/(sigma(k)*si(2))^2);

   end
  
   
fig=gcf;

delete(findobj(0,'name','filter ratios'));
hf=figure('name','filter ratios','numbertitle','off','units','normalized','position',[0.0660    0.6285    0.2986    0.2801]);

ratio=sqrt((Rz(2:end,:)./Rz(1:end-1,:)-1)*2/fac);

plot(fz',ratio',fz',Rz')

set(0,'currentfigure',fig)


for k=1:numf

  R1=Rz(k,:)'*ones(1,si(2));
  R2=ones(si(1),1)* Rs(k,:);
  
%  R1=fftshift(R1);
%  R2=fftshift(R2);
    
  
  Rfz(:,:,k)=R1.*freq.*D;
  Rfs(:,:,k)=R2.*freq.*D;

end

figname=get(gcf,'name');

for k=1:numf
set(gcf,'name',['LFE ' num2str(k)]);   
drawnow;
   

Rfz(:,:,k)=ifft2(fftshift(Rfz(:,:,k)));
Rfs(:,:,k)=ifft2(fftshift(Rfs(:,:,k)));
%Rfz(:,:,k)=ifft2roi(Rfz(:,:,k),BW);
%Rfs(:,:,k)=ifft2roi(Rfs(:,:,k),BW);

end

SRfz=sum(Rfz(:,:,1:end-1),3);
SRfz(SRfz == 0) = tresh;
SRfs=sum(Rfs(:,:,1:end-1),3);
SRfs(SRfz == 0) = tresh;

SIG_Z=sqrt((sum(Rfz(:,:,2:end),3)./SRfz-1)*2/fac)*0.5;
SIG_S=sqrt((sum(Rfs(:,:,2:end),3)./SRfs-1)*2/fac)*0.5;


%SIG=real(sqrt(om0^2 * si(1)^2 ./ SIG_Z.^2 + om0^2 * si(2)^2 ./ SIG_S.^2));
%SIG=SIG*dist*(numf-1);
 
SIG=real(om0./sqrt(SIG_Z.^2 + SIG_S.^2))*dist;
%SIG(find(BW == 0))=0;
para=[numf sigma(1) fac om0 tresh dist flag];
set(gcf,'name',figname);

   