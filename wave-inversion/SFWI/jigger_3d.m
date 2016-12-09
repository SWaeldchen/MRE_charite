function u_jig = jigger_3d(u, nJig)
u_jig = u;
for xJig = 0:nJig-1
    for yJig = 0:nJig-1
        for zJig = 0:nJig-1
            u_jig = u_jig + circshift(u, [xJig yJig zJig]);
        end
    end
end
u_jig = (u_jig - u ) / nJig^3;
