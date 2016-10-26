
%==========================================================================
% function img = read_image_data(hdr)
%==========================================================================
function img = spm_read_image_data_eb(hdr)
img = [];

if hdr.SamplesPerPixel ~= 1,
    warning('spm:dicom','%s: SamplesPerPixel = %d - cant be an MRI.', hdr.Filename, hdr.SamplesPerPixel);
    return;
end;

%prec = ['ubit' num2str(hdr.BitsAllocated) '=>' 'uint32'];
prec = ['uint' num2str(hdr.BitsAllocated) '=>' 'uint32'];

if isfield(hdr,'TransferSyntaxUID') && strcmp(hdr.TransferSyntaxUID,'1.2.840.10008.1.2.2') && strcmp(hdr.VROfPixelData,'OW'),
    fp = fopen(hdr.Filename,'r','ieee-be');
else
    fp = fopen(hdr.Filename,'r','ieee-le');
end;
if fp==-1,
    warning('spm:dicom','%s: Cant open file.', hdr.Filename);
    return;
end;

if isfield(hdr,'NumberOfFrames'),
    NFrames = hdr.NumberOfFrames;
else
    NFrames = 1;
end

if isfield(hdr,'TransferSyntaxUID')
    switch(hdr.TransferSyntaxUID)
    case {'1.2.840.10008.1.2.4.50','1.2.840.10008.1.2.4.51',... % 8 bit JPEG & 12 bit JPEG
          '1.2.840.10008.1.2.4.57','1.2.840.10008.1.2.4.70',... % lossless NH JPEG & lossless NH, 1st order
          '1.2.840.10008.1.2.4.80','1.2.840.10008.1.2.4.81',... % lossless JPEG-LS & near lossless JPEG-LS
          '1.2.840.10008.1.2.4.90','1.2.840.10008.1.2.4.91',... % lossless JPEG 2000 & possibly lossy JPEG 2000, Part 1
          '1.2.840.10008.1.2.4.92','1.2.840.10008.1.2.4.93' ... % lossless JPEG 2000 & possibly lossy JPEG 2000, Part 2
         },
        % try to read PixelData as JPEG image
        fseek(fp,hdr.StartOfPixelData,'bof');
        fread(fp,2,'uint16'); % uint16 encoding 65534/57344 (Item)
        offset = double(fread(fp,1,'uint32')); % followed by 4 0 0 0
        fread(fp,2,'uint16'); % uint16 encoding 65534/57344 (Item)
        fread(fp,offset);
        
        sz  = double(fread(fp,1,'*uint32'));
        img = fread(fp,sz,'*uint8');

        % Next uint16 seem to encode 65534/57565 (SequenceDelimitationItem), followed by 0 0

        % save PixelData into temp file - imread and its subroutines can only
        % read from file, not from memory
        tfile = tempname;
        tfp   = fopen(tfile,'w+');
        fwrite(tfp,img,'uint8');
        fclose(tfp);

        % read decompressed data, transpose to match DICOM row/column order
        img = uint32(imread(tfile)');
        delete(tfile);
    case {'1.2.840.10008.1.2.4.94' ,'1.2.840.10008.1.2.4.95' ,... % JPIP References & JPIP Referenced Deflate Transfer
          '1.2.840.10008.1.2.4.100','1.2.840.10008.1.2.4.101',... % MPEG2 MP@ML & MPEG2 MP@HL
          '1.2.840.10008.1.2.4.102',                          ... % MPEG-4 AVC/H.264 High Profile and BD-compatible
         }
         warning('spm:dicom',[hdr.Filename ': cant deal with JPIP/MPEG data (' hdr.TransferSyntaxUID ')']);
    otherwise
        fseek(fp,hdr.StartOfPixelData,'bof');
        img = fread(fp,hdr.Rows*hdr.Columns*NFrames,prec);
    end
else
    fseek(fp,hdr.StartOfPixelData,'bof');
    img = fread(fp,hdr.Rows*hdr.Columns*NFrames,prec);
end
fclose(fp);
if numel(img)~=hdr.Rows*hdr.Columns*NFrames,
    error([hdr.Filename ': cant read whole image']);
end;

img = bitshift(img,hdr.BitsStored-hdr.HighBit-1);

if hdr.PixelRepresentation,
    % Signed data - done this way because bitshift only
    % works with signed data.  Negative values are stored
    % as 2s complement.
    neg      = logical(bitshift(bitand(img,uint32(2^hdr.HighBit)),-hdr.HighBit));
    msk      = (2^hdr.HighBit - 1);
    img      = double(bitand(img,msk));
    img(neg) = img(neg)-2^(hdr.HighBit);
else
    % Unsigned data
    msk      = (2^(hdr.HighBit+1) - 1);
    img      = double(bitand(img,msk));
end;

img = reshape(img,[hdr.Columns,hdr.Rows,NFrames]);

