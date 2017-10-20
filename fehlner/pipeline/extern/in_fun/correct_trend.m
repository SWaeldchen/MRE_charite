function W2=correct_trend(W,BW)
%
% W2=correct_trend(W,BW)
% W is 4D or 5D
% BW = 2D-array
% 

si=size(W);

if length(si) == 4
    
    inc=0; 
    for ks=1:si(3) 
        for kt=1:si(4)  
            tmp=W(:,:,ks,kt); 
            inc=inc+1; 
            A(inc)=mean(tmp(BW)); 
        end
    end
    AA=unwrap(A)-A;
    inc=0; 
    for ks=1:si(3) 
        for kt=1:si(4)  
            inc=inc+1;
            W2(:,:,ks,kt)=W(:,:,ks,kt)+AA(inc); 
        end
    end

end


%%%%%5D%%%%%

if length(si) == 5
    
    inc=0;
    for kc=1:si(5)
    for ks=1:si(3) 
        for kt=1:si(4)  
            tmp=W(:,:,ks,kt,kc); 
            inc=inc+1; 
            A(inc)=mean(tmp(BW)); 
        end
    end
    end
    AA=unwrap(real(A))-A;
    inc=0; 
    for kc=1:si(5)
    for ks=1:si(3) 
        for kt=1:si(4)  
            inc=inc+1;
            W2(:,:,ks,kt,kc)=W(:,:,ks,kt,kc)+AA(inc); 
        end
    end
    end

end

figure 
plot(1:inc,real(A),1:inc,unwrap(real(A)))
