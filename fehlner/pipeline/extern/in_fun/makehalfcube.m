function SIG2=makehalfcube(SIG)
%
% makes half cube out of a quarter cube
%

SIG2=cat(3,flipdim(SIG,3),SIG(:,:,2:end));
