function F=ivpd(lamda,voxel)
% intravoxel phasedispersion

x=linspace(0,2*pi,100);



for k=1:max(size(voxel))
    
     phaseshift=0.5*lamda/voxel(k)

     A=[];

     for l=1:1000

    A(l,:)=sin(x*lamda+pi/phaseshift*l/1000);
    
    end
    
    
    B(k,:)=sum(A/1000);
    
end

F=sum(abs(B),2);