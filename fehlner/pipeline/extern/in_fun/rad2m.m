function A=rad2m(f_vib,f_grad,N_grad,grad_amp,grad)
% 
% conversion rad to meters
% A=rad2m(f_vib,f_grad,N_grad,grad_amp,grad);
% example:
% A=rad2m(linspace(1,1000,100),500,2,35,'sin');plot(linspace(1,1000,100),1./A);title('efficiency of motion encoding; gradient: 500 Hz 35 mT/m Amplitude')
% u[m] = A*phi[rad]
% ingolf.sack@charite.de

%if f_grad == f_vib % avoid singularity
if mod(f_vib,f_grad) == 0 % avoid singularity
    %disp(f_vib)
    f_vib=f_vib+0.1;
end

gyro=2.6704e+005;

if f_vib > 0 % MRE
q=f_vib./f_grad;

switch grad
    case 'sin'
A = -(pi.*f_grad./gyro./grad_amp.*(1 - q.^2)./sin(pi*N_grad.*q)); % sin gradient
    case 'cos'
A = -(pi.*f_grad./gyro./grad_amp./q.*(q.^2-1)./sin(pi*N_grad.*q)); % cos gradient
    otherwise
        error('grad either ''sin'' or ''cos''!')
end

% equivalent to the inverse formula given by eq.1 in Asbach et al. Magn. Reson. Med. 60:373-379

else % first momentum (constant flow)
    
   A =  2*pi*f_grad.^2/gyro/grad_amp;
end