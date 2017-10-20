function lfe_gauss_1D
%
% calcs lfe gaussian with sigma variation
%


w=get(gco,'Ydata');
X=get(gco,'Xdata');

 Le=length(w);

        para=[2 1 1 0.2 0.01 1 1];

   prompt={'number of filters:','sigma 1:','fac:','excitation frequency:','replace amplitude nulls with:',...
           'distance per pixel:','flag for complex LFE (1) or real LFE (0)'};
   def={num2str(para(1)),num2str(para(2)),num2str(para(3)),num2str(para(4)),num2str(para(5)), num2str(para(6)),num2str(para(7))};
   dlgTitle='Input for LFE Gauss 1D';
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
   
%%%%%%% make sigma%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  for k=2:numf
      
      sigma(k)=sqrt(1/(1/sigma(k-1)^2 - fac));
      
  end
  
  disp([ 'sigma gauss: ' num2str(sigma) ]);
  %%%%%%%%%%%%%%%%%%Calc starts%%%%%%%%%%%%%%%%%%%%%%
   
     
   if ~odd(Le)
       Le+1;
   end
   
   f=linspace(-Le/2,Le/2,Le);

   freq=fftshift(fft(w,Le));
 %  [freq, BW]=fft2roi(w); 
   
   D=ones(1,Le);
   
   if flag
   D(:,1:round(Le/2))=0;
   end

   for k=1:numf
       
   R(k,:)=exp(-0.5*f.^2/(sigma(k)*Le)^2);
 
   end
  
   
fig=gcf;

delete(findobj(0,'name','filter ratios'));
hf=figure('name','filter ratios','numbertitle','off','units','normalized','position',[0.0660    0.6285    0.2986    0.2801]);

ratio=sqrt((R(2:end,:)./R(1:end-1,:)-1)*2/fac);

plot(f',ratio',f',R')

set(0,'currentfigure',fig)


Rf=R.*(ones(numf,1)*(freq.*D));

figname=get(gcf,'name');

for k=1:numf
set(gcf,'name',['LFE ' num2str(k)]);   
drawnow;
   

Rf(k,:)=ifft(fftshift(Rf(k,:)));

end

SRf=sum(Rf(1:end-1,:),1);
SRf(SRf == 0) = tresh;

SIG=sqrt((sum(Rf(2:end,:),1)./SRf-1)*2/fac);

SIG=SIG*Le;
%SIG=real(om0./SIG*dist);

figure
a=plot(X,SIG)
set(a,'Buttondownfcn','smooth_1d');

axis tight
