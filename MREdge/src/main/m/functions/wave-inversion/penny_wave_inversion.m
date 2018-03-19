% eg4 - inhomogeneous example
%

clear%, close all
format short e

N = 32;
e = 1E-1;
I = i;

H = 2*pi/N;
Hinv = 1/H;  %% = N/(2*pi)
onevec = ones(1,floor(N/2));

x = [0:N].'*H;
xmid = x(1:N) + 0.5*H;

muex = (1 + e*(2*xmid + I - 2*I*exp(-2*I*xmid)))./(1 + e*(2*xmid - I));
u = (1 + 2*e*x).*exp(2*I*x);

Du(1:N,1) = (u(2:N+1) - u(1:N))/H;  %% approx u' at midpts

A = spdiags([Du -Du], 0:1, N, N);
A(N,1:2:N) = onevec;
A(N,2:2:N) = -onevec;

b(1:N-1,1) = u(2:N);
b(N,1) = 0;
b = 4*H*b;
mu = A\b;

res = A*muex -b;
Mres = max(abs(res));
err = mu -muex;
%[Mres, max(abs(err))]

iaxR = [0,35,0.5,1.5];
iaxI = [0,35,0,0.4];

figure(1)
subplot(2,1,1), plot([1:N],real(mu),'b-', [1:N],real(muex),'r--'), grid on
ylabel('Real(\mu)'), title('1D coefficient: no noise'), axis(iaxR)
legend(['calc'],['exact'])
subplot(2,1,2), plot([1:N],imag(mu),'b-', [1:N],imag(muex),'r--'), grid on
xlabel('N'), ylabel('Imag(\mu)'), axis(iaxI)

%===============================================================================
%Now do it for noisy data

Nsim = 50;
eps = 2/100;  % noise level
eps1 = 1 - 0.5*eps;

Ru = zeros(N+1,1);
for isim = 1:Nsim
  r1 = rand([N+1,1]);
  Ru = Ru + u.*(eps1 + eps*r1);   
end

Ru = Ru/Nsim;
relerr =(Ru - u)./abs(u);

Du(1:N,1) = (Ru(2:N+1) - Ru(1:N))/H;  %% approx u' at midpts

A = spdiags([Du -Du], 0:1, N, N);
A(N,1:2:N) = onevec;
A(N,2:2:N) = -onevec;

b(1:N-1,1) = Ru(2:N);
b(N,1) = 0;
b = 4*H*b;
Rmu = A\b;

resR = A*muex -b;
MresR = max(abs(resR));
Rerr = Rmu -muex;
%[Mres, max(abs(err))]

figure(2)
subplot(2,1,1), plot([1:N],real(Rmu),'b-', [1:N],real(muex),'r--'), grid on
ylabel('Real(\mu)'), title(['1D coefficient: noise = ', num2str(100*eps),'%, nsamp = ', int2str(Nsim)])
legend(['calc'],['exact']), axis(iaxR)
subplot(2,1,2), plot([1:N],imag(Rmu),'b-', [1:N],imag(muex),'r--'), grid on
xlabel('N'), ylabel('Imag(\mu)'), axis(iaxI)

