function [h_ttest,h_signrank,p_ttest,p_signrank] = plotmseb(DATA1,DATA2,plotfig,filename)

DATA1(isnan(DATA1)) = 0;
DATA2(isnan(DATA2)) = 0;

for kslice = 1:size(DATA1,1)
    [p_signrank(kslice),h_signrank(kslice)] = signrank(squeeze(DATA1(kslice,:)),squeeze(DATA2(kslice,:)));
    [h_ttest(kslice),p_ttest(kslice)] = ttest(squeeze(DATA1(kslice,:)),squeeze(DATA2(kslice,:)));
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if strcmp(plotfig,'yes')
    figure
    hold on,
    mseb([],mean(DATA1,2)',std(DATA1,[],2)',[],1);
    % hold on, plot(DATA1,'b.')
    lineProps.col={'r'}; mseb([],mean(DATA2,2)',std(DATA2,[],2)',lineProps,1);
    % hold on, plot(DATA2,'r.')
    DATA3 = DATA2 - DATA1;
    lineProps.col={'g'}; mseb([],mean(DATA3,2)',std(DATA3,[],2)',lineProps,1);
    hline2(0.05);
    %plot(p_signrank,'k-.');
    %hold on
    plot(h_signrank*50,'c-.');
    hold on
    %xlim([90 140]);
    %ylim([-abs(max([A1 A2])) abs(max([A1 A2]))])
    xlim([20 70]);
    set(gcf,'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);    
    saveas(gcf,filename);
    close
end
end