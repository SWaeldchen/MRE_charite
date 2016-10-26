function [alpha_min mu_min]=springpot_fit_complex_hirn(G,freq,eta)

%  [alph mu] = springpot_fit_complex_hirn(gr + i*gi,freq,3.7);
%
% fit springpot  
% see Maple-file "springpot"
% eta2=(mu1/mu2)^((1-alpha)/alpha) % f�r eta1 = 1 Pas

if nargin < 3
    eta = 1;
end

if  G == 0    
    disp('error in G:')
    disp(G)
    alpha_min = NaN;
    mu_min = NaN;
    return
end

alpha=linspace(0,0.5,200)'*ones(1,1000);
MU=ones(200,1)*linspace(1/100,10,1000)*1000;
%CHI=zeros(200,500);
x=freq*0;
y=freq*0;


for F=1:length(freq)
        
        om=2*pi*freq(F);
        G_mod=MU.^(1-alpha) .*  (i*om*eta).^alpha;
        tmp=(real(G(F))-real(G_mod)).^2+(imag(G(F))-imag(G_mod)).^2;
        [x(F) y(F)]=find(tmp == min(tmp(:)));
        end

% 
%  if size(chi,3) > 1
% % %CHI=mean(smooth3(chi,'box',[5 5 1]),3);
%  CHI=mean(smooth3(chi,'box',filt),3);
%  else
%  CHI=chi;
%  end

% CHI=mean(chi,3);
% [x y]=find(CHI == min(CHI(:)));

x=round(median(x));
y=round(median(y));

mu_min=MU(x,y);
alpha_min=alpha(x,y);