function Y=cyclcoi2(S90,S0,w1,U90,U0,w2,num,r,s,phi)
%
% Y=cyclcoi2(S90,S0,w1,U90,U0,w1,num,r)
%

S0r=S0+(rand(80)*2-1)*mean(mean(abs(S0)))*r;
U0r=U0+(rand(80)*2-1)*mean(mean(abs(U0)))*r;
S90r=S90+(rand(80)*2-1)*mean(mean(abs(S90)))*r;
U90r=U90+(rand(80)*2-1)*mean(mean(abs(U90)))*r;


   w=cat(3,S0r,S90r,U0r,U90r);
   %ws=smooth3(w,'box',[s s 1]);
   ws(:,:,1)=fftsmooth(w(:,:,1),s);
   ws(:,:,2)=fftsmooth(w(:,:,2),s);
   ws(:,:,3)=fftsmooth(w(:,:,3),s);
   ws(:,:,4)=fftsmooth(w(:,:,4),s);
   
   
   S1c=ws(:,:,1);+i*ws(:,:,2);
   S2c=ws(:,:,2);+i*ws(:,:,1);
   U1c=ws(:,:,3);+i*ws(:,:,4);
   U2c=ws(:,:,4);+i*ws(:,:,3);
   
   Y=zeros(size(S90));
   N=0;
   
   if nargin < 10 
   for k=1:num
      N=N+1;
      [SIG,D,D]=coi_pix2(S2c,S1c,w1,U2c,U1c,w2);
      Y=Y+real(SIG);
      
   end
   else
      disp('use phi')
      for k=1:num
      N=N+1;  
      SIG=coi_pix3(S2c,S1c,w1,phi(1),phi(2),U2c,U1c,w2,phi(3),phi(4));
      Y=Y+real(SIG);   
      end
   end
   
      
      
   Y=Y/N;
   
   plot2dwaves(Y)