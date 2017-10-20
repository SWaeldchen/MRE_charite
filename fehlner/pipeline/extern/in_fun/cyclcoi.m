function Y=cyclcoi(S90,S0,w1,U90,U0,w2)
%
% SIG=cyclcoi(S90,S0,w1,U90,U0,w2) 
%

S0r=S0+(rand(80)*2-1)*mean(mean(abs(S0)))*0.25;
U0r=U0+(rand(80)*2-1)*mean(mean(abs(U0)))*0.25;
S90r=S90+(rand(80)*2-1)*mean(mean(abs(S90)))*0.25;
U90r=U90+(rand(80)*2-1)*mean(mean(abs(U90)))*0.25;

m=0;
K=0;
dim=size(S0);
Y=zeros(dim(1),dim(2),71);

   
for k=5:5:355
   K=K+1;
   disp(k)
   
   S1=makewave(k,S90r,90,S0r);
   S2=makewave(k+90,S90r,90,S0r);
   U1=makewave(k,U90r,90,U0r);
   U2=makewave(k+90,U90r,90,U0r);
   
   w=cat(3,S1,S2,U1,U2);
   ws=smooth3(w,'box',[5 5 1]);
   
   S1c=ws(:,:,1)+i*ws(:,:,2);
   S2c=ws(:,:,2)+i*ws(:,:,1);
   U1c=ws(:,:,3)+i*ws(:,:,4);
   U2c=ws(:,:,4)+i*ws(:,:,3);
   
   if (k ~= 180)
   SIG=coi_pix3(S1c,S2c,w1,k,90,U1c,U2c,w2,k,90);
	end

   tmp(:,:,K)=real(SIG);
   
end


Y=sum(tmp,3)/K;
plot2dwaves(Y);


   