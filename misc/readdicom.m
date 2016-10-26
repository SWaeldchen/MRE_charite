function [dicomVolume] = readdicom(path)

cd(path);
dicomlist = dir(fullfile(pwd,'*.dcm'));
dicomVolume = [];
for cnt = 1 : numel(dicomlist)
    dicomVolume = cat(3, dicomVolume, dicomread(fullfile(pwd,dicomlist(cnt).name)));  
end
dicomVolume = double(dicomVolume);