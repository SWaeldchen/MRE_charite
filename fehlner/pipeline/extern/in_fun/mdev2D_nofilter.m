function [ABSG PHI C]=mdev2D_nofilter(C,freqs,comps,weight,pixel_spacing,filt,BW) %#ok<INUSL>
    
    % [ABSG PHI C]=mdev2D(C,freqs,comps,weight,pixel_spacing,filt,[3D-ROI for spatial averaging in same dimension as C(:,:,:,1,1)])
    % [ABSG PHI C]=mdev2D(CURLDIV,[60 30 50 40 45 35 55],[1 2 3],[0 1 1 1 0 1 0],[2.4615 2.4615]/1000,60,BW);
    %
    % or: 
    % 
    % [ABSG PHI C]=mdev2D(CURLDIV,[60 30 50 40 45 35 55],[1 2 3],[0 1 1 1 0 1 0],[2.4615 2.4615]/1000,100,BW);
    %
    % i.s. 11.3.2013

    om = freqs*2*pi;

    numer_phi = 0;
    denom_phi = 0;
    numer_G = 0;
    denom_G = 0;

    if nargin < 7   
       BW = [];
    end



    if size(C,5) ~= length(om)
        error('size CURL along 5th dimension doesn''t match number of freqs')
    end

    if length(freqs) ~= length(weight)
        error('same number of frequencies and weights are needed!!')
    end

    
    for k_freq = 1:length(freqs)
        for kc=comps

           fprintf('+')

        %      for k_filter=1:size(C,3)
        %     
        %         C(:,:,k_filter,kc,k_freq) = uh_filtspatio2d(C(:,:,k_filter,kc,k_freq),[pixel_spacing(1); pixel_spacing(2)],filt,1,0,5, 'bwlow', 0);
        %         
        %      end

                U = C(:,:,:,kc,k_freq)*weight(k_freq);

                [wx wy]   = gradient(U,pixel_spacing(1),pixel_spacing(2),1);
                [wxx tmp] = gradient(wx,pixel_spacing(1),pixel_spacing(2),1); %#ok<NASGU>
                [tmp wyy] = gradient(wy,pixel_spacing(1),pixel_spacing(2),1);

                DU=wxx+wyy;

                if isempty(BW)

                numer_phi=numer_phi+ real(DU).*real(U)+imag(DU).*imag(U);
                denom_phi=denom_phi+ abs(DU).*abs(U);

                numer_G=numer_G + 1000*om(k_freq).^2.*abs(U);
                denom_G=denom_G + abs(DU);        

                else

                    DU1=sum(DU(BW));
                    DU2=sum(abs(DU(BW)));
                    U1=sum(U(BW));
                    U2=sum(abs(U(BW)));

                numer_phi=numer_phi+ real(DU1).*real(U1)+imag(DU1).*imag(U1);
                denom_phi=denom_phi+ abs(DU2).*abs(U2);

                numer_G=numer_G + 1000*om(k_freq).^2.*abs(U2);
                denom_G=denom_G + abs(DU2);

                end

        end % components
    end % frequencies


    denom_phi(denom_phi == 0) = eps;
    denom_G(denom_G == 0) = eps;


    PHI = acos(-numer_phi./denom_phi);
    ABSG = numer_G./denom_G;

end

    