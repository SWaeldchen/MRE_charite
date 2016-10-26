function y = parsquare(x)
% PARSQUARE.M
% shows how parallel loops could be used to slice a 5D array into 3D
% volumes and processed in parallel
%% test for 5D
if (ndims(x) < 5 || ndims(x) > 5) 
    display('5D data only please');
    return;
end
%% create pool
poolobj = gcp('nocreate');
if isempty(poolobj)
    parpool;
end
%% change 5D obj into 3D cells
sz = size(x);
x_cell = cell(sz(4), sz(5));
for m = 1:sz(4)
    for n = 1:sz(5)
        x_cell{m}{n} = x(:,:,:,m,n);
    end
end
%% perform operations in parallel on each cell
y_cell = cell(sz(4), sz(5));
parfor m = 1:sz(4)
    for n = 1:sz(5)
        temp = x_cell{m}{n};
        squared = temp.^2;
        y_cell{m}{n} = squared;
    end
end
%% pass back to single object
y = zeros(sz);
for m = 1:sz(4)
    for n = 1:sz(5)
        y(:,:,:,m,n) = y_cell{m}{n};
    end
end
