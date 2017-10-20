function smoothconvolution
%
% smooth with normalized convolution (according to Knutsson et.al)
% filter function: Gauss
% weigthing function: first derivative
%

    im=get(gca,'children');
    im=findobj(im,'type','image');
    r=get(im,'CData');

ma=round(max(max(r)));
si=size(r);
start(1)=ma/10;
start(2)=si(1)/4;
quest='No';

while strcmp(quest,'No')
   
	prompt={['tolerance (max: ' num2str(ma) '):'],'sigma:'};
   def={num2str(start(1)),num2str(start(2))};
   dlgTitle='Input for Smooth Gaussian';
   lineNo=1;
   answer=inputdlg(prompt,dlgTitle,lineNo,def);
   
   if isempty(answer)
      return
   end
   
   toli=str2num(answer{1});
   sigma=str2num(answer{2});
	start=[toli sigma];   


ds=find((diff(r',1,2) > toli) | (diff(r',1,2) < -toli));
W=r';
W(ds)=0;
W=W';
ds=find((diff(r,1,2) > toli) | (diff(r,1,2) < -toli));
W(ds)=0;

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

A=exp(-fz.^2/sigma)'*exp(-fs.^2/sigma);

cg=W.*r;
fcga=(fftshift(fft2(cg)).*A);
cga=fftshift(fft2(fcga));
cga=fftshift(fft2(cga));
cga=fftshift(fft2(cga));

fca=fftshift(fft2(W)).*A;
ca=fftshift(fft2(fca));
ca=fftshift(fft2(ca));
ca=fftshift(fft2(ca));


ratio=abs(cga./ca);
set(im,'CData',ratio);
set(gca,'climmode','auto')
drawnow;

quest=questdlg('accept smoothing???');

if strcmp(quest,'Cancel');
   set(im,'CData',r);
elseif strcmp(quest,'No');
   set(im,'CData',r);
end
end % while
