path = fullfile(getenv('MRE'), 'm-code', 'GuidedLap');
currd = pwd;
cd(path)
mex -v GuidedLap.cpp WaveletGuidedLaplacian.o
cd(currd)