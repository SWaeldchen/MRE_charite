function [vec, E]=fit_ing_2(t,F,T2,er)
% inversion einer nichtquadratischen Matrix
%

T=1./T2;

num=length(T2);
 
for k=1:num    
 
    E(:,k)=exp(-T(k)*t(:));
 end

 for k=1:length(er)
     
    vec(:,k)=pinv(E'*E)*E'*(F(:)+er(k));

 end
 
 
plot(T2,vec)
