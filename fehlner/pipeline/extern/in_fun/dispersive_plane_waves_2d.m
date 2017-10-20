function u = dispersive_plane_waves_2d(springpot_mu,springpot_alpha,freqs,inverse_SNR)
%
% u = dispersive_plane_waves_2d(ReG,ImG,freqs,inverse_SNR)
%

if nargin < 1
freqs   = 20;
ReG = 1000;
ImG = 500;
inverse_SNR= 0.02;
end
u0  = 1;
d   = 1e-3*[2 2];
M   = 128;
N   = 128;
u = zeros(M,N,length(freqs));

eta=3.7;
%eta=1;

for k=1:length(freqs)
    
    kappa=springpot_mu^(1-springpot_alpha)*eta^springpot_alpha;
    ReG=kappa*cos(pi/2*springpot_alpha)*(2*pi*freqs(k))^springpot_alpha;
    ImG=kappa*sin(pi/2*springpot_alpha)*(2*pi*freqs(k))^springpot_alpha;
    absG=sqrt(ReG^2+ImG^2);
    phi=atan(ImG/ReG);
    disp(num2str([absG phi]))
    
    u(:,:,k) = sim_dispersive_plane_waves_2d(u0,absG,phi,M,N,freqs(k),d,inverse_SNR);
    
end;


function u = sim_dispersive_plane_waves_2d(u0,absG,phi,M,N,f,d,RSNR)

% S.Papazoglou 21.11.2012
% 
% u = sim_dispersive_plane_waves_2d(u0,absG,phi,M,N,f,d,RSNR)
% 
% absG : Betrag des komplexen Moduls
% phi  : Phase des komplexen Moduls. Werte zwischen 0 und pi/4 sind
%        physikalisch sinvoll. Daempfung nimmt mit phi zu.
% M    : Anzahl der Zeilen im Bild.
% N    : Anzahl der Spalten im Bild.
% f    : Frequenz
% d    : Raeumliche Aufloesung [dx dy] ([Zeilen Spalten])
% RSNR : Reziprokes SNR

om = 2*pi*f;
dx = d(1);
dy = d(2);

[x,y] = meshgrid(0:dy:(N-1)*dy,0:dx:(M-1)*dx);

G = absG*(cos(phi)+i*sin(phi));
k = om/sqrt(G/1000);

theta = 0/180*pi;% Propagationsrichtung; in Richtung Spalten: theta = 0, Zeilen: theta = pi/2
u     = u0*exp(-i*k*(cos(theta)*x+sin(theta)*y)) + RSNR*(randn(M,N) + i*randn(M,N));
