function filter2D_fMRE(W,mask,k_freq)
% read Fourier-transformed complex wave images and takes the first hamronic
% (2nd component)
% W=filter2D_fMRE(fW,mask,3);

% filter für 30 35 40 & 45 Hz
f2=[0.0178 0.0159 0.014 0.0122];
f1=[0.15 0.127   0.114   0.104];

    
dx=1.9/1000;


   %% ROI for filtering
  se = strel('disk',3); 
   
   
  

    
    for ks=1:7
          for kc=1:3
                for kv=1:6
    
                 %W_filt(:,:,ks,kc,kv) = uh_filtspatio2d(W(:,:,ks,2,kc,kv).*imdilate(mask(:,:,ks),se),[dx; dx],1/f2(k_freq),5,1/f1(k_freq),5, 'bwbwband', 0);
                 [W1(:,:,ks,kc,kv) W2(:,:,ks,kc,kv) W3(:,:,ks,kc,kv) W4(:,:,ks,kc,kv)] = is_filtspatiotemp2d(W(:,:,ks,2,kc,kv).*imdilate(mask(:,:,ks),se),[dx; dx],1/f2(k_freq),5,1/f1(k_freq),5, 'bwbwband');
                 
    fprintf('.')
                end
          end
    end
    
    freqs=[30 35 40 45];
    save(['W' num2str(freqs(k_freq)) '_filt_1'],'W1')
    save(['W' num2str(freqs(k_freq)) '_filt_2'],'W2')
    save(['W' num2str(freqs(k_freq)) '_filt_3'],'W3')
    save(['W' num2str(freqs(k_freq)) '_filt_4'],'W4')