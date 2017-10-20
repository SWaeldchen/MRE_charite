function ws=fftsmooth(w,toli)

% smooth wave image after 2D-fft
% discard all data points below a treshold

if nargin <1

   im=get(gca,'children');
    im=findobj(im,'type','image');
    w=get(im,'CData');
tmp=w;

toli=1/10;
end


nochmal=1;
while nochmal
   
if nargin <1   
   prompt={'tolerance:'};
   def={num2str(toli)};
   dlgTitle='Input smooth fft';
   lineNo=1;
   answer=inputdlg(prompt,dlgTitle,lineNo,def);

   
   if isempty(answer)
       return
   end
   
   
   toli=str2num(answer{1});
end

   w=fftshift(fft2(w));
   w(find(abs(w) < max(max(abs(w)))*toli ))=0;
   w=fftshift(fft2(w));
   w=fftshift(fft2(w));
   w=fftshift(fft2(w));
   
   

    
if nargin <1
   set(im,'Cdata',real(w));
   butt=questdlg('accept smoothing result?');

switch butt
case 'Yes'
    nochmal=0;
case 'Cancel'
    set(im,'Cdata',real(tmp));
    return
case 'No'    
    w=tmp; 
    set(im,'Cdata',real(w));
end
else
   nochmal=0;
end

end

ws=real(w);