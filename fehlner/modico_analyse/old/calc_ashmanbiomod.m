function D = calc_ashmanbiomod(mu1,mu2,std1,std2)

    D = (mu1-mu2) / ((std1^2+std2^2)/2)^(1/2);
%     D = abs(mu1-mu2) / ((std1^2+std2^2)/2)^(1/2);

end