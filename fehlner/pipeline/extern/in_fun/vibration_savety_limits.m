function [u1, u2]=vibration_savety_limits(f,measure_time)
% [u1, u2]=vibration_savety_limits(f,measure_time)
% measure time in min

omega=2*pi*f;

%a_rms=100*f/100;

tau=sqrt(8*60/measure_time);
a_rms_wholebody=1.15*f/16*tau;
a_rms_extremity=5*f/16*tau;

u1=a_rms_wholebody./omega.^2*sqrt(2);
u2=a_rms_extremity./omega.^2*sqrt(2);

plot(f,u1*1e3,f,u2*1e3);
legend('whole body','extremity')
title(['EU vibration safety limits for ' num2str(measure_time) ' min measure time'])
xlabel('frequency [Hz]')
ylabel('maximum allowed displacement [mm]')