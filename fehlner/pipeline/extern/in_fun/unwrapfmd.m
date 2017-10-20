function w = unwrapfmd(W,BW)
% w_unwrap=unwrapfmd(w_wrap,[BW])
% phase unwrapping using flyn's algorithm
%

w = zeros(size(W));

command = ['/home/andi/work/mretools/extern/flynn/Flynn -input ','tmp_in',' -format ','float',' -output ','tmp_out',' -xsize ',num2str(size(W,1)),' -ysize ',num2str(size(W,2)), ' -bmask ','tmp_mask > /dev/null'];


if nargin < 2
    BW = W(:,:,1)*0+1;
end

fmask = fopen ('mask_fmd', 'w' );
fwrite ( fmask, BW, 'int8' );
fclose ( fmask );


for k = 1:size(W,3)
    
    if (length(size(BW)) == 3)
        BWcur = BW(:,:,k);
    end    
    
    fprintf('+')
    f = fopen ('tmp_in','w' );
    fwrite ( f, W(:,:,k), 'float32' );
    fclose ( f );
    
    system( command );
    
    f = fopen ( 'tmp_out', 'r');
    [t,blubb] = fread ( f,size(W,1)*size(W,2),'float32' );
    tmp = reshape ( t, size(W,1),size(W,2));
    fclose ( f);
    
    w(:,:,k) = tmp;
    
    if nargin > 1
        % ganzzahlige 2-pi-Spr�nge:
        %    w(:,:,k)=tmp-round(mean(tmp(BW))/2/pi)*2*pi;
        w(:,:,k) = tmp-mean(tmp(BWcur(:)));
    end
    
end

warning off
    delete('tmp_out');
    delete('tmp_in');
    delete('mask_fmd');
warning on