function y = sg_interp_smooth(x)
    sg = [-0.0839
        0.0210
        0.1026
        0.1608
        0.1958
        0.2075
        0.1958
        0.1608
        0.1026
        0.0210
       -0.0839];
    y =  convn(x, sg, 'same');
end