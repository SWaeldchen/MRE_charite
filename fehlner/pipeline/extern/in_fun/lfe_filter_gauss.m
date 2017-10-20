function R=lfe_filter_gauss(f,sigma)
%
% gaussian filter function
%


X=length(sigma);
R=zeros(X,length(f));
for k=1:X
   

tmp = -0.5/sigma(k)*f.^2;
R(k,:)=exp(tmp);

end
