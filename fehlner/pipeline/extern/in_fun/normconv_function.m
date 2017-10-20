function ratio=normconv_function(w,toli,sigma,flag)
%
% normalized convolution (Knutson)
% ratio=normconv_function(w, toli,sigma)
%
if nargin < 4
    flag=0;
end

if nargin < 2
   prompt={'tolerance:','sigma:'};
   def={'2','200'};
   dlgTitle='Input for Smooth Gaussian';
   lineNo=1;
   answer=inputdlg(prompt,dlgTitle,lineNo,def);
   
   if isempty(answer)
      return
   end
   
   toli=str2num(answer{1});
   sigma=str2num(answer{2});
   
end

%ds=find((diff(w',1,2) > toli) | (diff(w',1,2) < -toli));
%W=w';
%W(ds)=0;
%W=W';
%ds=find((diff(w,1,2) > toli) | (diff(w,1,2) < -toli));
%W(ds)=0;

W=w;
if flag

ds=find((W > toli) | (W < -toli));

else
    
ds=find((del2(W) > toli) | (del2(W) < -toli));

end
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






