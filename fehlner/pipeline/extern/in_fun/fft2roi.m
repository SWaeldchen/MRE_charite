function [SIG, BW]=fft2roi(w,BW)
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

for k=1:size(w,1)

cut=find(BW(k,:) == 1);


%SIG(k,cut)=fftshift(fft(w(k,cut)));
SIG(k,cut)=fft(w(k,cut));

end


for k=1:size(w,2)

cut=find(BW(:,k) == 1);


%SIG(cut,k)=fftshift(fft(SIG(cut,k)));
SIG(cut,k)=fft(SIG(cut,k));

end
