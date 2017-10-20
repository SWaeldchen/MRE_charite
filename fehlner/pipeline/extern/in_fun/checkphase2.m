function NS=checkphase2(A,pos,prec,pix,str)
%
% A: 2D array
%

if nargin < 3
    prec = 1;
end
if nargin < 4
    pix = [1 1];
end

if nargin < 5
    str='o';
end


dim=size(A);
for k=1:dim(2)
    
    [tmp, XX, YY]=nulls1D(A(:,k),prec);
    
               
    NS(:,k)=tmp(pos);
    
end

%figure;
 plot((1:dim(2))'*pix(1),NS'/prec*pix(2),str);