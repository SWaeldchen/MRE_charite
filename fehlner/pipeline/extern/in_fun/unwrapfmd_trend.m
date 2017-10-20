function w=unwrapfmd(W,BW)
% w_unwrap=unwrapfmd(w_wrap,[BW])
% phase unwrapping using flyn's algorithm
%

w=zeros(size(W));
command = ['C:\algexe\Flynn.exe -input ',    'tmp_in',' -format ','float',' -output ','tmp_out',' -xsize ',num2str(size(W,1)),' -ysize ',num2str(size(W,2)),' -bmask ','mask',' > NUL'];
%command = ['C:\algexe\Flynn.exe -input ',    'tmp_in',' -format ','float',' -output ','tmp_out',' -xsize ',num2str(size(W,1)),' -ysize ',num2str(size(W,2)),' > NUL'];
 if nargin > 1
fmask = fopen ('mask', 'w' );
fwrite ( fmask, BW, 'int8' );
fclose ( fmask );
 end


for k=1:size(W,3)
fprintf('+')    
f = fopen ('tmp_in','w' );
fwrite ( f, W(:,:,k), 'float32' );
fclose ( f );

dos ( command );

f = fopen ( 'tmp_out', 'r');
[t,blubb] = fread ( f,size(W,1)*size(W,2), 'float32' );
w(:,:,k) = reshape ( t, size(W,1),size(W,2));
fclose ( f);


end

delete('tmp_out')
delete('tmp_in')
delete('mask')