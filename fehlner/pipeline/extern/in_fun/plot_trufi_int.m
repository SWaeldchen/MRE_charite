function phase_signal=plot_trufi_int(meg_freq,meg_cyc,meg_ramp_up,meg_amp,vibration_freq,vibration_cycle_number,vibration_phase,sequence)
%
% phase_signal=plot_trufi_int(meg_freq,meg_cyc,meg_ramp_up,meg_amp,vibration_freq,vibration_cycle_number,vibration_phase,sequence)
% phase_signal=plot_trufi_int(110,[1 1],0.29,[1 1],2*46.3,2,linspace(0,360,100));

phase_signal=zeros(1,length(vibration_phase));


for k=1:length(vibration_phase)
    
t_tot=vibration_cycle_number/vibration_freq*1000;
t=linspace(0,t_tot,10000);
vib=sin(2*pi*t/t_tot*vibration_cycle_number+vibration_phase(k)*pi/180);

tau=1000/meg_freq/2;
dw=t(2)-t(1);
meg1=[linspace(0,1,round(meg_ramp_up/dw)), linspace(1,1,round((tau-2*meg_ramp_up)/dw)), linspace(1,0,round(meg_ramp_up/dw))];
meg2=[meg1, -meg1];

if length(meg_cyc) == 1
    meg=[];

for N=1:meg_cyc
    meg=[meg meg2];
end

meg(end+1:length(t))=0;
meg=meg(1:length(t))*meg_amp(1);

else

    meg_pre=[];
    meg_post=[];
for N=1:meg_cyc(1)
    meg_pre=[meg_pre meg2];
end

for N=1:meg_cyc(2)
    meg_post=[meg_post meg2];
end

if length(meg_amp) == 1
    meg_amp=[meg_amp meg_amp];
end

meg=t*0;
meg(1:length(meg_pre))=meg_pre*meg_amp(1);
meg(end-length(meg_post)+1:end)=meg_post*meg_amp(2);

meg=meg(1:length(t));


end

      
        


phase_signal(k)=sum(vib.*meg)*dw;
plot(t,vib,t,meg,t,cumsum(vib.*meg)*dw)
axis tight
title(['TE: ' num2str(t_tot) 'ms freq: ' num2str(1/t_tot*1000) 'Hz freq app: ' num2str(vibration_cycle_number/t_tot*1000) 'Hz'])
drawnow
end