function [vec, E]=fit_ing(t,F,T2,er,schwer)
%
% vec=fit_ing(t,F,T2)
% t: time vector
% F: experimental data points
% T2: [T2min T2max]
%

if nargin < 4
    schwer =0;
end

num=length(F);
T=linspace(1/T2(1),1/T2(2),num);
X=1./T;
E=zeros(num);
G=zeros(num);

 for k=1:num    
 
    E(:,k)=exp(-T(k)*t(:));
    %E(:,k)=exp(-((X(:)-X(k))/er).^2);
 end

 for k=1:length(er)
     
    vec(:,k)=pinv(E-eye(num)*er(k))*(F(:));

end

vec=mean(vec,2);
plot(X,vec)
if schwer


vec2=vec;
vec2(vec2 < 0) =0;
    
    for k=1:size(schwer,1)
    ind = find((X > schwer(k,1)) & (X <schwer(k,2)));
    x=X(ind);
    
    y=(vec2(ind));
    
    S(k)=sum(y(:).*x(:))/sum(y);
    
    hold on
    Ylim=get(gca,'Ylim');
    line([S(k) S(k)],Ylim,'color','red');
    line([schwer(k,1) schwer(k,1)],Ylim,'color','green','linestyle','--');
    line([schwer(k,2) schwer(k,2)],Ylim,'color','green','linestyle','--');
end
% disp(S')
end
    