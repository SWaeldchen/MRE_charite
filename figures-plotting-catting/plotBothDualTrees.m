function plotBothDualTrees(vector)
[Faf Fsf] = FSfarras;
[af sf] = dualfilt1;
dt = dualTree.DualTree;
plotMatlabDualTree(dualtree(vector, 3, Faf, af)); 
plotJavaDualTree(dt.forward1d(vector, 3));