function SIG3=makefullcube(SIG)
%
% makes full cube out of a quarter cube
%

SIG2=cat(3,flipdim(SIG,3),SIG(:,:,2:end));
SIG3=cat(2,flipdim(SIG2,2),SIG2(:,2:end,:));