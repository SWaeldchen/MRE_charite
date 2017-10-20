function [R, sigma]=knutsonfilterX_2(f,f0,numf)
%   filterfun(f,f0,numf)
%   f: frequency vector
%   f0: centre frequency
%   find the proper bandwidth in order to have a linear ratio function f02 / f01
%   f0(1) < f0(2)!
%   knutson function


x=find(f == 0);
f(x)=0.000001;

fac=(f0(2)/f0(1))^(1/(numf-1));

R=zeros(numf,length(f));
B=2*sqrt(2*log2((f0(1)*fac)/f0(1)));
CB=4/(B^2 * log(2));

pos=f0(1);

for k=1:numf

sigma(k)=pos;

R(k,:)=exp(-CB*(log(abs(f)/pos)).^2);

pos=pos*fac;
   
end

