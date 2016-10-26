% 'GenLamTable' generates the table of lambda for desired output 
%  standard deviation for OGS2['pen'] with group size (K1,K2).
%  All of group size (K1,K2) are
%  K1 = [1 1 1 1 1 2 2 2 2 3 3 3 4 4 5 2]; 
%  K2 = [1 2 3 4 5 2 3 4 5 3 4 5 4 5 5 8];
%
%  Input :
%          pen: penalty function (eg., pen = 'abs', 'log', 'rat', 'atan')
%          Nit: number of iteration
%          realcompl: 'real' or 'complex'
%          stdo1, stdo2: desired output std 
%  Output : 
%          Output are put in the folder ./lambda_data,
%  
%          
%  Po-Yu Chen and Ivan Selesnick,
%  August 2013

function GenLamTable(pen, Nit, realcompl, stdo1, stdo2)
randn('state', 0);
N1 = 1000;
N2 = 1000;

if stdo1 < stdo2
   temp = stdo1;
   stdo1 = stdo2;
   stdo2 = temp;
end
    
switch realcompl
    case 'real'
        y = randn(N1, N2);
    case 'complex'
        y = ( randn(N1, N2) + 1i*randn(N1, N2) ) / sqrt(2);
    otherwise
        disp('realcompl should be real or complex.')
        return
end


    
num = 5; % size of lam
K1 = [1 1 1 1 1 2 2 2 2 3 3 3 4 4 5 2]; 
K2 = [1 2 3 4 5 2 3 4 5 3 4 5 4 5 5 8];
lam = zeros(length(K1), num);
std_v = lam;

for i = 1 : length(K1)
    A = @(y, lam) ogs2(y, K1(i), K2(i), lam, pen, 1, Nit);
    clc
    dlam = 10^-4;
    
    if i == 1
      switch pen
          case 'abs'
              switch realcompl
                  case 'real'
                      std_fun = @(t) sqrt( 2*(1+t^2)*qfunc(t) - t*sqrt(2/pi)*exp(-t^2/2) );
                  case 'complex'
                      std_fun = @(t) sqrt( exp(-t^2)-2*sqrt(pi)*t*qfunc(sqrt(2)*t) );  
              end
               
              lam1 =  bisect_abs11(stdo1, dlam, realcompl);
              lam2 =  bisect_abs11(stdo2, dlam, realcompl);
              lam(i,:) = linspace(lam1, lam2, num);
              for j = 1 : length(lam(i,:))
                  std_v(i,j) = std_fun(lam(i,j));
              end
          otherwise
              lam1 =  bisect(A, stdo1, dlam, N1, N2, realcompl);
              lam2 =  bisect(A, stdo2, dlam, N1, N2, realcompl);
              lam(i,:) = linspace(lam1, lam2, num);
              for j = 1 : length(lam(i,:))
                  [x, cost] = A(y, lam(i,j));
                  std_v(i,j) = std(x(:));
              end
      end
      
    else  
       lam1 =  bisect(A, stdo1, dlam, N1, N2, realcompl);
       lam2 =  bisect(A, stdo2, dlam, N1, N2, realcompl);
       lam(i,:) = linspace(lam1, lam2, num);
       for j = 1 : length(lam(i,:))
           [x, cost] = A(y, lam(i,j));
           std_v(i,j) = std(x(:));
       end
    end
    
    figure(1)
    clf
    h = semilogy(lam(i,:), std_v(i,:),'.-');
    set(h, 'markersize', 20)
    xlabel('lambda')
    ylabel('std')
    ylim([0.7*10^-4 10^-2*1.2])
    grid on
end
txt_lam = sprintf('./lambda_data/lam_%s_%s_Nit_%2d.txt', pen, realcompl, Nit);
txt_std = sprintf('./lambda_data/std_%s_%s_Nit_%2d.txt', pen, realcompl, Nit);

Lam = [K1' K2' lam];
STD = [K1' K2' std_v];
save(txt_lam,'-ascii','Lam');
save(txt_std,'-ascii','STD');



