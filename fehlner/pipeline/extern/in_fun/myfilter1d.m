function  d = myfilter1d(data,nl,nr,m,a)

% data    Datenvektor
% nl      linke Grenze des 'moving window'
% nr      rechte Grenze 
% m       Ordnung des Polynoms, welches gefittet werden soll
% a       bei 
% a=1     gibt den geglaetteten Datensatz zurück
% a=2     erste Ableitung
% a=3     zweite Ableitung

n = length(data);

B = savgol1d(nl,nr,m);
b = B(a,:);

tmp = zeros(1,nr+nl+n);
tmp(1,nl+1:n+nr) = data';

for k=nl+1:1:nl+n
    d(k-nl) = tmp(k-nl:k+nr)*b';  
end;