function y=fourierseries(shape,n,P)

k=(1:n);
x=linspace(0,2*pi*P,200);
K=k(:)*(x*0+1);

switch shape
    
    case 'triang0'
        y= 4/pi*sum(1./(2*K-1).^2.*cos((2*k(:)-1)*x),1);
    case 'triang90'
        y= 4/pi*sum((-1).^(K-1).*1./(2*K-1).^2.*sin((2*k(:)-1)*x),1);

    case 'rect0'
        y= 4/pi*sum(1./(2*K-1).*sin((2*k(:)-1)*x),1);
    case 'rect90'
        y= 4/pi*sum((-1).^(K-1).*1./(2*K-1).*cos((2*k(:)-1)*x),1);

    case 'saw0'
        y= 2/pi*sum(1./K.*sin(k(:)*x),1);
    case 'saw90'
        %y=-2/pi*sum(1./K.*sin(k(:)*x),1);
        y= 2/pi*sum((-1).^(K-1).*1./K.*sin(k(:)*x),1);
end
        
        