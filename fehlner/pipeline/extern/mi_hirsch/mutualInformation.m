function mi = mutualInformation(data1, mask1, data2, mask2, g1, g2)

if (size(data1) ~= size(data2))
	disp('Error: Both datasets need to have the same dimensions');
	return;
end

[size_x size_y size_z] = size(data1);

m=mask1 & mask2;

if (nargin == 4)
	% normalize data, so that all unmasked gray values lie between 0 and 1
	d1 = data1(m);
	g1min = min(d1);
	g1max = max(d1);
	
	d2 = data2(m);
	g2min = min(d2);
	g2max = max(d2);
	
	clear d1 d2;
else
	g1min = g1(1);
	g1max = g1(2);
	g2min = g2(1);
	g2max = g2(2);
	
end

m = m & (data1<=g1max) & (data1>=g1min) & (data2>=g2min) & (data2<=g2max);
data1(m) = (data1(m)-g1min)/(g1max-g1min);
data2(m) = (data2(m)-g2min)/(g2max-g2min);

nBins=256;
figure('Name', 'Difference image');
imagesc(data1(75:112,30:112,1)-data2(75:112,30:112,1));

h = zeros(nBins,nBins);
h1 = zeros(nBins,1);
h2 = zeros(nBins,1);

stepSize = 1/nBins;
count = 0;

% Entropy for the joint histogram
for x=1:size_x
	for y=1:size_y
		for z=1:size_z
			if (m(x,y,z) == 0)
				continue;
			end
			
			c1 = ceil(data1(x,y,z)/stepSize);
			c1 = max(c1,1); %ensure that c1 >= 1
			c2 = ceil(data2(x,y,z)/stepSize);
			c2 = max(c2,1);
			h(c1,c2) = h(c1,c2)+1;
			h1(c1) = h1(c1)+1;
			h2(c2) = h2(c2)+1;
			count = count+1;
		end
	end
end

h = h/count;
%figure('Name', 'Joint histogram');
%imagesc(h);
h1 = h1/count;
h2 = h2/count;

mi = 0;
for p=1:nBins
	for q=1:nBins
		if (h(p,q) == 0)
			continue;
		end
		mi = mi + h(p,q)* reallog(h(p,q)/(h1(p)*h2(q)));
	end
end

disp(sprintf('Normalized mutual information: %.3f', mi));
