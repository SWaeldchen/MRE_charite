function shownulls(W,DIM)
%
%
%

W=W(:,:,1);
dim=size(W);


if nargin < 2
    DIM = 3;
end

Wft_1=fft(W,[],1);
Wft_2=fft(W,[],2);

Wft_1(1:(dim(1)/2),:)=0;
Wft_2(:,1:(dim(1)/2))=0;

W2_1=ifft(Wft_1,[],1);
W2_2=ifft(Wft_2,[],2);


switch DIM
    
case 1
    
  %  plot2dwaves(imag(W2_1)./real(W2_1));
    plot2dwaves(real(W2_1)./imag(W2_1));

    
case 2
    
 %   plot2dwaves(imag(W2_2)./real(W2_2));
    plot2dwaves(real(W2_2)./imag(W2_2));

otherwise
    
%    plot2dwaves(0.5*(imag(W2_1)./real(W2_1)+imag(W2_2)./real(W2_2)));  % 0°
  
   plot2dwaves(0.5*(real(W2_1)./imag(W2_1)+real(W2_2)./imag(W2_2)));   % 90°
  
    
end


clear caxis;

caxis([-3 3]);