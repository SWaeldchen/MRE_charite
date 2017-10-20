function [c,g, G]=dispersionskurve(para,f,model)
% [c,g, G]=dispersionskurve(para,f,model)
% z.B.: [c,g]=dispersionskurve([1050,30,2000,20000],[25 37.5 50 62.5],'zener');
% oder f=linspace(0,75,100);
% [c,g]=dispersionskurve([1050,30,2000,20000],f,'zener');
%
% voigt/maxwell: para = [rho,eta,mu]
% springpot:     para = [rho,alpha,mu, eta]      !ohne eta ist vorgegeben: eta = 1 !
% zener:         para = [rho,eta,mu1,mu2]
% jeffreys:      para = [rho,eta1,eta2,mu]
% zener_frak:    para = [rho,eta,mu1,mu2,alpha]

omega = 2*pi*f;

switch model
    
    case 'voigt'
        
        rho = para(1);
        eta = para(2);
        mu  = para(3);
        
        c = 2^(1/2)/rho^(1/2)*(mu^2+eta^2*omega.^2).^(1/2)./((mu^2+eta^2*omega.^2).^(1/2)+mu).^(1/2);
        g = 1/2*omega*2^(1/2)*rho^(1/2)./(mu^2+eta^2*omega.^2).^(1/2).*((mu^2+eta^2*omega.^2).^(1/2)-mu).^(1/2);
        G = mu + i*omega*eta;
        
        
    case 'maxwell'
        
        rho = para(1);
        eta = para(2);
        mu  = para(3);
        
        c = 2^(1/2)/rho^(1/2)*eta^(1/2)*omega.^(1/2)*mu^(1/2)./(mu^2+eta^2*omega.^2+eta*omega.*(mu^2+eta^2*omega.^2).^(1/2)).^(1/2).*(mu^2+eta^2*omega.^2).^(1/4);
        g = 1/2*2^(1/2)*rho^(1/2)/eta^(1/2)/mu^(1/2)*omega.^(1/2)./(mu^2+eta^2*omega.^2).^(1/4).*(mu^2+eta^2*omega.^2-eta*omega.*(mu^2+eta^2*omega.^2).^(1/2)).^(1/2);
        G = omega*eta*mu./(mu+omega*eta*i)*i;
        
    case 'springpot'
        
        
        rho    = para(1);
        alpha  = para(2);
        mu     = para(3);
        
        if length(para) > 3
            eta = para(4);
        else
            eta = 1;
        end
        
        c = 2^(1/2)/rho^(1/2)*omega.^(1/2*alpha)*mu^(-1/2*alpha+1/2)*eta^(1/2*alpha)/(1+cos(1/2*alpha*pi))^(1/2);
        g = 1/2*2^(1/2)*omega.^(1-1/2*alpha)*rho^(1/2)*mu^(1/2*alpha-1/2)*eta^(-1/2*alpha)*(1-cos(1/2*alpha*pi))^(1/2);
        G = mu*(omega*eta/mu*i).^alpha;
        
    case 'zener'
        
        rho = para(1);
        eta = para(2);
        mu1 = para(3);
        mu2 = para(4);
        
        c = 2^(1/2)/rho^(1/2)*(mu2^2*mu1^2+mu2^2*eta^2*omega.^2+2*eta^2*omega.^2*mu1*mu2+mu1^2*eta^2*omega.^2).^(1/2)./(mu1*mu2^2+eta^2*omega.^2*mu2+eta^2*omega.^2*mu1+(mu2^2+eta^2*omega.^2).^(1/2).*(mu2^2*mu1^2+mu2^2*eta^2*omega.^2+2*eta^2*omega.^2*mu1*mu2+mu1^2*eta^2*omega.^2).^(1/2)).^(1/2);
        g = 1/2*omega*2^(1/2)*rho^(1/2)./(mu2^2*mu1^2+mu2^2*eta^2*omega.^2+2*eta^2*omega.^2*mu1*mu2+mu1^2*eta^2*omega.^2).^(1/2).*(-mu1*mu2^2-eta^2*omega.^2*mu2-eta^2*omega.^2*mu1+(mu2^2+eta^2*omega.^2).^(1/2).*(mu2^2*mu1^2+mu2^2*eta^2*omega.^2+2*eta^2*omega.^2*mu1*mu2+mu1^2*eta^2*omega.^2).^(1/2)).^(1/2);
        G = (mu1*mu2+omega*eta*(mu1+mu2)*i)./(mu2+omega*eta*i);
        
    case 'jeffreys'
        
        rho  = para(1);
        eta1 = para(2);
        eta2 = para(3);
        mu   = para(4);
        
        c = 2^(1/2)/rho^(1/2)*eta1^(1/2)*omega.^(1/2).*(mu^2+eta2^2*omega.^2).^(1/2)./(omega*mu*eta1+(mu^2+eta2^2*omega.^2).^(1/2).*(mu^2+eta2^2*omega.^2+2*eta2*omega.^2*eta1+eta1^2*omega.^2).^(1/2)).^(1/2);
        g = 1/2*2^(1/2)*rho^(1/2)/eta1^(1/2)./(mu^2+eta2^2*omega.^2).^(1/2).*omega.^(1/2).*(-omega*mu*eta1+(mu^2+eta2^2*omega.^2).^(1/2).*(mu^2+eta2^2*omega.^2+2*eta2*omega.^2*eta1+eta1^2*omega.^2).^(1/2)).^(1/2);
        
    case 'zener_frak'
        
        rho    = para(1);
        eta    = para(2);
        mu1    = para(3);
        mu2    = para(4);
        alpha  = para(5);
        
        G_k = mu1+mu2*(omega*eta/mu2*i).^alpha./(1+(omega*eta/mu2*i).^alpha);
        
        c = abs(1./real(sqrt(rho./G_k)));
        g = abs(omega.*imag(sqrt(rho./G_k)));
        
    otherwise
        
        error('wrong model, use terms ''voigt'', ''maxwell'', ''springpot'', ''zener'', ''jeffreys'' or ''zener_frak'' !')
        
end

