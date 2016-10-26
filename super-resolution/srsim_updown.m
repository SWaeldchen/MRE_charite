figure();
ud = x_updown_abs(:,1);
inda = 196;
indb = 200;
subplot(3, 1, 1); plot(ud); xlim([inda indb]);
udl = x_updown_abs_lap(:,1);
subplot(3, 1, 2); plot(udl); xlim([inda indb]);
subplot(3, 1, 3); plot(ud ./ udl); xlim([inda indb]);