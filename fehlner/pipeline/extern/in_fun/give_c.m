function give_c




pos=ginput(2);
        hold on
        h=plot(pos(:,1),pos(:,2));
c=abs(diff(pos(:,2))./diff(pos(:,1)));

title(['c = ' num2str(c) ' m/s mu = c^2*rho (1000 kg/m³)' num2str(c^2) ' kPa' ])