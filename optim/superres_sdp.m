% Script to perform super-resolution of spikes from low frequency
% measurements. More specifically, the locations of the nonzeros components 
% of x are determined from measurements of the form y=Fx where F is the low 
% pass operator that maps a function in the unit interval to its 2fc+1 lower
% Fourier series coefficients. Recovery is carried out by solving:
% 
% max_u Re(y'u) 
% subject to max_ j |( F*u )_j | <= 1
% 
% using an equivalent SDP formulation. The script uses CVX
% (http://cvxr.com/cvx/).
%
% For more information see the paper "Towards a mathematical theory of 
% super-resolution" by E. Candes and C. Fernandez-Granda. 

clear all
rand('state',271) % random seed fixed so that the example is the one in the paper

% Problem data 

% cutoff frequency
fc = 50;
nspikes = floor(7*fc/16);
% nominal spacing
tnominal = (0:nspikes-1);
% spike locations
tspikes = (tnominal + rand(1,nspikes)./16).*16./(7*fc); 
% amplitudes 
dynamic_range=35;
x = (-1).^randint(nspikes,1) .* (1 + 10.^(rand(nspikes,1).*(dynamic_range/20))); % amplitudes can also be complex

% data 
k = -fc:1:fc;
F = exp(-1i*2*pi*k'*tspikes); % Fourier matrix
y = F*x; n = length(y);

%% Solve SDP

cvx_solver sdpt3
cvx_begin sdp 
    variable X(n+1,n+1) hermitian;
    X >= 0;
    X(n+1,n+1) == 1;
    trace(X) == 2;
    for j = 1:n-1,
        sum(diag(X,j)) == X(n+1-j,n+1);
    end
    maximize(real(X(1:n,n+1)'*y))
cvx_end

u = X(1:n,n+1);

%% Plot result

% k = 0:(2*fc);
dualpoly = @(t)  exp(1i*2*pi*t'*k) * u;

t = linspace(0,1,1e4);
figure, plot(t,abs(dualpoly(t)))
hold on,
plot(tspikes, ones(1,nspikes),'r*')
hold off;
legend('|F*u|','Support of x')

%% Roots of dual polynomial

aux_u =- conv(u,flipud(conj(u)));
aux_u(2*fc+1)=1+aux_u(2*fc+1);
k2 = (-2*fc):(2*fc);
roots_pol = roots(flipud(aux_u));

figure, plot(real(roots_pol),imag(roots_pol),'*')
hold on,
plot(cos(2*pi*tspikes), sin(2*pi*tspikes),'ro')
hold off;
legend('Roots','Support of x')

% Isolate roots on the unit circle
roots_detected = roots_pol(abs(1-abs(roots_pol)) < 1e-4);
[auxsort,ind_sort]=sort(real(roots_detected));
roots_detected = roots_detected(ind_sort);
% Roots are double so take 1 and out of 2 and compute argument
t_rec = angle(roots_detected(1:2:end))/2/pi;
% Argument is between -1/2 and 1/2 so convert angles
t_rec(t_rec < 0)= t_rec(t_rec < 0) + 1;  
% Accuracy 
delta = abs(sort(t_rec') - sort(tspikes));
fprintf('Maximum error: %9.4e\n',max(delta));
fprintf('Average error: %9.4e\n',sum(delta)/length(delta))

% low resolution signal
low_freq = 0;
for ind_spike = 1:length(tspikes)
    aux_sinc= sin(2.*pi.*(fc+1/2).*(t-tspikes(ind_spike)))./sin(pi.*(t-tspikes(ind_spike)))./(2*fc+1);
    low_freq = low_freq + x(ind_spike).*aux_sinc;
end
F_est = exp(-1i*2*pi*k'*t_rec'); % estimated Fourier matrix
x_est = F_est\y; % estimated amplitudes
figure, plot(t,low_freq)
hold on,
plot(tspikes, x,'k*')
stem(t_rec,x_est,'r')
hold off;
legend('low resolution signal','original signal','estimated signal','Location','NW')
xlim([0.07 0.38])
ylim([-10 25])
