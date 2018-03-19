
% Use standardImport for importing data without any further user interaction
% Image series are identified as mreCubes if they contain at least 3 time steps and exactly 3 directions
[mreCubes otherMagnitudeCubes otherComplexCubes]=standardImport(inputPath,outputPath);

% importWithGui enables the user to select the input and the output folder interactively. Furthermore it can be used to concatenate directions or frequencies from different image series
importWithGui;
