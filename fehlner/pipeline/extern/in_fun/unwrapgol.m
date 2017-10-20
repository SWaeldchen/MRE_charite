function w=unwrapgol(W,BW)
% w=unwrapgol(W,BW)
% phase unwrapping using Goldstein algorithm
%

w=zeros(size(W));

if nargin < 2
command = ['C:\algexe\Goldstein.exe -input ','tmp_in',' -format ','float',' -output ','tmp_out',' -xsize ',num2str(size(W,1)),' -ysize ',num2str(size(W,2))];
else
fmask = fopen ('mask', 'w' );
fwrite ( fmask, BW, 'int8' );
fclose ( fmask );

command = ['C:\algexe\Goldstein.exe -input ','tmp_in',' -format ','float',' -output ','tmp_out',' -xsize ',num2str(size(W,1)),' -ysize ',num2str(size(W,2)),' -bmask ','mask'];
end

for k=1:size(W,3)
f = fopen ('tmp_in','w' );
fwrite ( f, W(:,:,k), 'float32' );
fclose ( f );

dos ( command );

f = fopen ( 'tmp_out', 'r');
t = fread ( f,size(W,1)*size(W,2), 'float32' );
tmp = reshape ( t, size(W,1),size(W,2));
fclose ( f);

 if nargin > 1
 % ganzzahlige 2-pi-Sprünge:
 %    w(:,:,k)=tmp-round(mean(tmp(BW))/2/pi)*2*pi;
 w(:,:,k)=tmp-mean(tmp(BW(:)));
 else
    w(:,:,k)=tmp;
 end
    
end

delete('tmp_out')
delete('tmp_in')
delete('mask')