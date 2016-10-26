function [gradX, gradY] = DT_diff(x, J)
if (nargin < 2) 
   J = 3;
end
[dfaf, dfsf, kern] = db_8_qshift;
[Faf, Fsf] = FSfarras;
[af, sf] = dualfilt1;
%w = cplxdual2D(x,J,dfaf,dfaf);
w = cplxdual2D(x,J,Faf,af);
gradX_dt = w;
gradY_dt = w;
% loop levels
for j = 1:J
    % loop trees
    for m = 1:2
        for n = 1:2
                gradX_dt{J+1}{m}{n} = diffX(w{J+1}{m}{n}, kern);
                gradY_dt{J+1}{m}{n} = diffY(w{J+1}{m}{n}, kern);
        end
    end
%gradX = icplxdual2D(gradX_dt,J,dfsf,dfsf);
%gradY = icplxdual2D(gradY_dt,J,dfsf,dfsf);
gradX = icplxdual2D(gradX_dt,J,Fsf,sf);
gradY = icplxdual2D(gradY_dt,J,Fsf,sf);
end

function g = diffX(f, kern)
    sz = size(f);
    g = convn(f, kern, 'same');
end

function g = diffY(f, kern) 
    g = diffX(f, kern');
end

function [dfaf, dfsf, kern] = db_8_qshift
    db8 = [-0.0105974018, 0.0328830117, 0.0308413818, -0.1870348117, ...
            -0.0279837694, 0.6308807679, 0.7148465706, 0.2303778133];
    dfaf{1} = [db8' (fliplr(db8).*(-1).^(1:8))'];
    dfaf{2} = flipud(dfaf{1});
    %dfaf{2} = dfaf{1};
    dfsf{1} = dfaf{2};
    dfsf{2} = dfaf{1};
    %dfsf = circshift(dfaf, [2 0]);
     kern = [-0.000008 0.0002 0.0022 -0.034 0.19 -0.79 0 -0.19...
            0.034 -0.0022 -0.0002 0.0000008];
end



