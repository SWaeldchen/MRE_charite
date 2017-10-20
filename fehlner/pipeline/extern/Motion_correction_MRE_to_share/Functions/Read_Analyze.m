function vol=Read_Analyze(filename,pathname,Bool)

if Bool
    currentdir=cd;
    cd(pathname);
    vol=analyze75read(filename);
    cd(currentdir);
end