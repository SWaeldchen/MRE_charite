function [all, velZ1, velZ2] = viewSim3
dims = load('/home/ericbarnhill/java-workspace/ViscoSim/sims/dims.txt');
x = dims(1);
y = dims(2);
z = dims(3);
ts = dims(4)-1;
velZ1 = load ('/home/ericbarnhill/java-workspace/ViscoSim/velZ40.csv');
velZ1 = reshape(velZ1', y, x, z, ts);
midpt = floor(z/2);
velZ1 = velZ1(:,:,midpt-5:midpt+5,:);

velZ2 = load ('/home/ericbarnhill/java-workspace/ViscoSim/sims/velZ.csv');
velZ2 = reshape(velZ2', y, x, z, ts);
midpt = floor(z/2);
velZ2 = velZ2(:,:,midpt-5:midpt+5,:);


all = cat(2, velZ1, velZ2);

openImage(all);