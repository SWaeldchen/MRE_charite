function phas=makecircularwaves(a)
%
%
%

phas=zeros(400,400);
 
rot=[cos(pi/180*a), -sin(pi/180*a); sin(pi/180*a), cos(pi/180*a)];

for K=1:200
    
    r=1/200*K;
    
    for L=1:200*K
        
        phi=2*pi/(200*K)*L;
        
        x=2*r*sin(phi);
        y=r*cos(phi);
        
        V=[x, y];
        V=V*rot;
        x=V(1);
        y=V(2);
        
        %[x, y]=pol2cart(phi,r);
        
        x=ceil(x*100+2*100+1);
        y=ceil(y*100+2*100+1);
        phas(y,x)=r;
        
    end
    
end

    