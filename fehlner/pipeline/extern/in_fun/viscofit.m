function x=viscofit(G,freq,model,eta)

% x=viscofit(G,freq,model,eta)
% so far fit springpot  



switch model
    
    case 'springpot'

if nargin < 4 
    eta = 1;
end

% see Maple-file "springpot"
% eta2=(mu1/mu2)^((1-alpha)/alpha) % für eta1 = 1 Pas

omega=i*freq*2*pi;

str='@(x)';
for k=1:length(omega)
str=[str 'abs(x(1)^(1-x(2))*' num2str(eta) '^x(2)*(' num2str(omega(k)) ')^x(2)-(' num2str(G(k)) '))+'];
end
str(end)=[];
%disp(str)
      x = fminsearch(eval(str),[1, 0.5]);


    otherwise
        error('we just have the springpot now')
end


% mu_min=x(1);          
% alpha_min=x(2);
% f2=linspace(0,max(freq)+max(freq)/10,100);
% mod=mu_min^(1-alpha_min)*eta^alpha_min*(i*2*pi*f2).^alpha_min;
% plot(f2,real(mod),f2,imag(mod),freq,real(G),'o',freq,imag(G),'s')
