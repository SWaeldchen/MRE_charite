
firstHarmonic=complexCube;
for index=1:length(complexCube) 
    firstHarmonic(index).cube=gunwrapFFT2(angle(complexCube(index).cube)); 
end;
[ firstHarmCorr ] = sliceWisePhaseCorrection( firstHarmonic );
