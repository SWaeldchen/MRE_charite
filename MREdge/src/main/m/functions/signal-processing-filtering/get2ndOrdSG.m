function [sg] = get2ndOrdSG(support)

switch support
    case 9
        sg = [-21 14 39 54 59 54 39 14 -21] ./ 231;
    case 7
        sg = [-2 3 6 7 6 3 -2] ./ 21;
    case 5
        sg = [-3 12 17 12 -3] ./ 35;
end