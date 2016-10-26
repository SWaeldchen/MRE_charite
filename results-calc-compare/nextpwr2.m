function [j,pwr] = nextpwr2(i)
    pwr = 0;
    while(2^(pwr) < i)
        pwr = pwr + 1;
    end
    j = 2.^pwr;
end
