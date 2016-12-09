dx = 10^-5;% spatial resolution in meter
L = 0.1;%image length in meter

% set the grid---------------------------
n = round(L / dx);%number of pixels
x = (1:n) * dx;
x = x - mean(x);
% x1 = x' * ones(1,n);%length in 1-direction (for 2D)
x1 = [-2*dx -dx 0 dx 2*dx]' * ones(1,n);%length in 1-direction (for 1D)
x2 = ones(size(x1,1),1) * x;%length in 2-direction
r = sqrt(x1.^2 + x2.^2);%radius in meter

% calculate the wave fields---------------------
ef = [0 0 1];%unit vector of the point surce deflection
ef = ef / norm(ef);
er = [1 1 0];%unit vector of the deflection detection
er = er / norm(er);

omega = 2*pi*50;%frequency
c0 = 1;%shear wave speed
k = omega / c0;%wave number

AmpNear = (3*dot(ef,er)*er - ef)/omega^2;%amplitude of the near field
AmpFar = -(dot(ef,er)*er - ef)/omega^2;%amplitude of the far field
uNear = AmpNear(3) * (-exp(-1i*(k*r+pi/2))./r.^3 + exp(-1i*pi/2)./r.^3) + k./r.^2.*exp(-1i*k*r);%near field
% plot2dwaves(real(uNear))
% plot2dwaves(angle(uNear))
uFar = -AmpFar(3) * k^2 ./ r .* exp(-1i*(k*r+pi/2));%far field
% plot2dwaves(real(uFar))
% plot2dwaves(angle(uFar))
u = uNear + uFar; %superimposed wave field
% u = exp(-1i*(k*x1));%plane wave

%calculate the complex shear modulus---------------
rho = 10^3;%density
Lu = 4 * del2(u, dx, dx);%laplace of the wave field
G = -rho * omega^2 * u ./ Lu;% Helmholz inversion: complex shear modulus

%plot the complex shear modulus----------
figure; plot(x, real(G(3,:))/10^3,'b')
hold on; plot(x, imag(G(3,:))/10^3,'r')
hold on; plot(x, abs(G(3,:))/10^3,'k')
hold on; plot(x, angle(G(3,:)),'g')
% plot2dwaves(abs(G))
% plot2dwaves(real(G)/10^3);caxis([0 3])
% plot2dwaves(imag(G))

%calculate the complex shear wave speed---------------
complexC = sqrt(G/rho);
complexK = omega./complexC;
c = omega./real(complexK);% shear wave speed
a = -omega/2/pi./imag(complexK);% penetration rate

%plot the complex shear wave speed----------
figure; plot(x, c(3,:),'b')
hold on; plot(x, a(3,:),'r')
% plot2dwaves(c);caxis([0 3])
