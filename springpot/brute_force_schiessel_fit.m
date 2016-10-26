function [muMap, alphaMap] = brute_force_schiessel_fit(G, freqs)
%function [muMap, etaMap, alphaMap] = brute_force_schiessel_fit(U, spacing, freqs)
% spacing in mm
rho = 1050;
freqs = freqs.*2.*pi;
fg = 0;
%{
laplacian = getLap();
lapU = convn(U, laplacian, 'same') ./ (spacing*spacing);
G = zeros(size(U));
%Gmag = zeros(size(U));
%Gphi = zeros(size(U));
for n = 1:numel(freqs);
    %Gmag(:,:,:,:,n) = rho .* freqs(n)^2 .* abs(U(:,:,:,:,n)) ./ abs(lapU(:,:,:,:,n));
    %Gphi(:,:,:,:,n) = acos( - ( real(U(:,:,:,:,n)).*real(lapU(:,:,:,:,n)) + ...
    %    imag(U(:,:,:,:,n)).*imag(lapU(:,:,:,:,n)) ) ./ (abs(U(:,:,:,:,n)).*abs(lapU(:,:,:,:,n))) );
    G(:,:,:,:,n) = rho*freqs(n)^2*U(:,:,:,:,n) ./ lapU(:,:,:,:,n);
end
%G = Gmag.*cos(Gphi) + 1i.*Gmag.*sin(Gphi);
G = squeeze(sum(G,4)); % sum components for now
G = abs(real(G)) + 1i*abs(imag(G));
assignin('base', 'G', G);
%}
muMap = zeros(size(G,1), size(G,2), size(G,3));
alphaMap = zeros(size(G,1), size(G,2), size(G,3));
%etaMap = zeros(size(G,1), size(G,2), size(G,3));
for y = 1:size(G,1)
    for x = 1:size(G,2)
        display(['Position ',num2str(x), ' ', num2str(y)]);
        for z = 1:size(G,3)
            Gvec = squeeze(G(y,x,z,:));
            valids = find(real(Gvec) > 500 & imag(Gvec) > 200);
            if (numel(Gvec(valids)) > 2) 
                %[mu, eta, alpha] = fit_schiessel_pot(Gvec(valids), freqs(valids));
                if (fg > 0)
                    fg = 0;
                end
                if (mod(x,10) == 0 && mod(y,10) == 0 && z == 4)
                    fg = 1;
                end
                [mu, alpha] = fitSchiessel2(real(Gvec(valids)), imag(Gvec(valids)), freqs(valids), fg);
                %display([num2str(x), ' ', num2str(y), ' ', num2str(z), ' ', ...
                %    num2str(mu), ' ', num2str(eta), ' ', num2str(alpha)])
                %display([num2str(mu), ' ', num2str(alpha)])
                muMap(x,y,z) = mu;
                %etaMap(x,y,z) = eta;
                %etaMap(x,y,z) = 1;
                alphaMap(x,y,z) = alpha;
            end
        end
    end
end

