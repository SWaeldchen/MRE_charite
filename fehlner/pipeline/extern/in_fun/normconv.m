function [sigma, toli]=normconvol(sigma, toli)
%
% normalized convolution (Knutson)
%

if nargin < 1
   prompt={'tolerance:','sigma:'};
   def={'2','200'};
   dlgTitle='Input for Smooth Gaussian';
   lineNo=1;
   answer=inputdlg(prompt,dlgTitle,lineNo,def);
   
   if isempty(answer)
      sigma = 0;
      toli = 0;
      return
   end
   
   toli=str2num(answer{1});
   sigma=str2num(answer{2});
   
end

im=get(gca,'children');
im=findobj(im,'type','image','visible','on');
w=get(im,'Cdata');


%ds=find((diff(w',1,2) > toli) | (diff(w',1,2) < -toli));
%W=w';
%W(ds)=0;
%W=W';
%ds=find((diff(w,1,2) > toli) | (diff(w,1,2) < -toli));
%W(ds)=0;

W=w;
ds=find((del2(W) > toli) | (del2(W) < -toli));
W(ds)=0;

%plot2dwaves(W);
num=length(find(W == 0));
num/prod(size(W));

si=size(w);
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

cg=W.*w;
fcga=(fftshift(fft2(cg)).*A);
cga=fftshift(fft2(fcga));
cga=fftshift(fft2(cga));
cga=fftshift(fft2(cga));

fca=fftshift(fft2(W)).*A;
ca=fftshift(fft2(fca));
ca=fftshift(fft2(ca));
ca=fftshift(fft2(ca));


ratio=abs(cga./ca);


set(im,'Cdata',ratio);

if nargin < 1
    
Q=questdlg('accept');

if ~strcmp(Q,'Yes')
    

set(im,'Cdata',w);

      sigma = 0;
      toli = 0;

end
    
end




