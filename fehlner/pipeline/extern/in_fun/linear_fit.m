function A=linear_fit(S,x,para,flag)
% 
% linear deconvolution of Gauss or Lorentz lines
% A=linear_fit(S,x,para,flag)
% S: signal vector
% x: x vector
% para: structured array of parameters
% flag: plot flag
%
% Beispiel Gauss-Line
%
% para.x0=[-0.5 0.1 0.5]
% para.T2=0.1
% para.fun='gauss'
%
% S=exp(-linspace(-1,1,100).^2/0.1.^2);
% A=linear_fit(S,linspace(-1,1,100),para,1)
%
% Beispiel Lorentz-Linen
%
% para.T2=[4 2]
% para.x0=[0 0.2]
% para.fun='lorentz'
%
% x=linspace(-1,1,100);
% S=4./(2*pi*i*4*(x-0)+1)+2./(2*pi*i*2*(x-0.2)+1);
% A=linear_fit(S,x,para,1)
%
% ingolf sack
% 2.11.2006


if nargin < 4
    flag =0;
end

num=length(para.x0);
F=zeros(num,length(x));


    if length(para.T2) ~= num
        T2=ones(1,num)*para.T2;
    else
        T2=para.T2;
    end


if strcmp(para.fun,'gauss')
    
        
    for k=1:num
        F(k,:)=exp(-((x-para.x0(k))/T2(k)).^2);
    end

elseif strcmp(para.fun,'lorentz')
    
    for k=1:num
        F(k,:)=real(T2(k)./(2*i*pi*T2(k)*(x-para.x0(k))+1));
    end

else
    
    error('wrong function: use either gauss or lorentz!')
    
end
    
%W=zeros(num);

% for k=1:num
% for L=1:num
%     
%     W(k,L)=sum(F(k,:).*F(L,:));
%     
% end
%     B(k)=sum(S(:)'.*F(k,:));
% end

W=F*F';
B=F*S(:);

A=W\B(:);

if flag
    
for k=1:num
plot(x,real(A(k)*F(k,:)),'r')
hold on
end


plot(x,real(sum((A*ones(1,length(x))).*F,1)),'k')
plot(x,real(S),'g')
axis tight

end