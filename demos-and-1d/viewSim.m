function [all, velX, velY, velZ, strXY, strXZ, strYZ, velZ2, res] = viewSim
dims = load('/home/ericbarnhill/java-workspace/ViscoSim/sims/dims.txt');
x = dims(1);
y = dims(2);
z = dims(3);
ts = dims(4)-1;
velX = load ('/home/ericbarnhill/java-workspace/ViscoSim/sims/velX.csv');
%y = size(velX, 2);
%x = y;
%z = numel(velX) / (y*x*ts);
velX = reshape(velX', y, x, z, ts);
velX = squeeze(velX(:,:,floor(z/2),:));
velY = load ('/home/ericbarnhill/java-workspace/ViscoSim/sims/velY.csv');
velY = reshape(velY', y, x, z, ts);
velY = squeeze(velY(:,:,floor(z/2),:));
velZ = load ('/home/ericbarnhill/java-workspace/ViscoSim/sims/velZ.csv');
velZ2 = reshape(velZ', y, x, z, ts);
velZ = squeeze(velZ2(:,:,floor(z/2),:));
strXY = load ('/home/ericbarnhill/java-workspace/ViscoSim/sims/strXY.csv');
strXY = reshape(strXY', y, x, z, ts);
strXY = squeeze(strXY(:,:,floor(z/2),:));
strXZ = load ('/home/ericbarnhill/java-workspace/ViscoSim/sims/strXZ.csv');
strXZ = reshape(strXZ', y, x, z, ts);
strXZ = squeeze(strXZ(:,:,floor(z/2),:));
strYZ = load ('/home/ericbarnhill/java-workspace/ViscoSim/sims/strXY.csv');
strYZ = reshape(strYZ', y, x, z, ts);
strYZ = squeeze(strYZ(:,:,floor(z/2),:));

vz2fft = fft(velZ2(:,:,:,end-15:end), [], 4);
vz2 = vz2fft(:,:,:,2);
laplacian = zeros(3,3,3); laplacian(1,1,2) = 1; laplacian(:,:,2) = [0 1 0; 1 -6 1; 0 1 0]; laplacian(3,3,2)=1;
vz2lap = convn(vz2, laplacian, 'same');
res = (abs(vz2) ./ abs(vz2lap));
openImage(res)


allVel = cat(2, velX, velY, velZ);
allStr = cat(2, strXY, strXZ, strYZ);
all = cat(1, allVel, allStr);
openImage(all);