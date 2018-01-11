% MREdge installation script

MREDGE_DIR = pwd;
fID = fopen('mredge_dir.txt', 'w');
fprintf(fID, '%s', MREDGE_DIR);