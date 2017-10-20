function W=w3D2w2D(w)

si=size(w);
col=ceil(sqrt(si(3))); 
row=ceil(si(3)/col);

inc=0;
W=zeros(si(1)*row,si(2)*col);
for c=0:col-1
    for r=0:row-1
        inc=inc+1;
        if inc <= si(3)
        W((1:si(1))+si(1)*r,(1:si(2))+si(2)*c)=w(:,:,inc);
        end
        
    end
end