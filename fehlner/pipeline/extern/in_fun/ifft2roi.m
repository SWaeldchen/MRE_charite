function [SIG, BW]=ifft2roi(w,BW)
%
%
%


if nargin < 2
plot2dwaves(w)
set(gcf,'name','select area')
BW=roipoly;
butt=get(gcf,'Selectiontype');
if strcmp(butt,'alt')
    BW=ones(size(w));
end

close(gcf)
end

SIG=zeros(size(w));

for k=1:size(w,2)

cut=find(BW(:,k) == 1);


%SIG(cut,k)=ifft(fftshift(SIG(cut,k)));
SIG(cut,k)=ifft(w(cut,k));

end

for k=1:size(w,1)

cut=find(BW(k,:) == 1);

%SIG(k,cut)=ifft(fftshift(w(k,cut)));
SIG(k,cut)=ifft(SIG(k,cut));

end


