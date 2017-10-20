function L=lorentz(freq,amp,freq0,T2);
%
% L=lorentz(freq,amp,freq0,T2);
% make complex Lorentz curve
% L=lorentz(linspace(0,10,1000),3,1,1);
%

L=amp./(i*2*pi*(freq-freq0)+1/T2);