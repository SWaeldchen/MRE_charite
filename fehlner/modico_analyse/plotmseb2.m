function res = plotmseb2(DATA1,DATA2,plotfig,filename)

%TMP_DATA1 = mean(DATA1,2); a=TMP_DATA1; a(a==0) = []; A1=[min(a) median(a) max(a)];
%TMP_DATA2 = mean(DATA2,2); a=TMP_DATA2; a(a==0) = []; A2=[min(a) median(a) max(a)];

%TMP_DATA1 = std(DATA1,[],2); a=TMP_DATA1; a(a==0) = []; A1=[min(a) median(a) max(a)];
%TMP_DATA2 = std(DATA2,[],2); a=TMP_DATA2; a(a==0) = []; A2=[min(a) median(a) max(a)];

DATA1(isnan(DATA1)) = 0;
DATA2(isnan(DATA2)) = 0;

for kslice = 1:size(DATA1,1)
    %for kslice = slice_s:slice_e
%     if length(squeeze(DATA1(kslice,:)==0)) || length(squeeze(DATA2(kslice,:)==0))
%         p_signrank(kslice) = 0;
%         h_signrank(kslice) = 1;
%         h_ttest(kslice) = 0;
%         p_ttest(kslice) = 1;
%     else
        [p_signrank(kslice),h_signrank(kslice)] = signrank(squeeze(DATA1(kslice,:)),squeeze(DATA2(kslice,:)));
        [h_ttest(kslice),p_ttest(kslice)] = ttest(squeeze(DATA1(kslice,:)),squeeze(DATA2(kslice,:)));
%    end
end

res.h_ttest = h_ttest;
res.h_signrank = logical(h_signrank);
res.p_ttest = p_ttest;
res.p_signrank = p_signrank;
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
    ABC = ylim;
    plot(h_ttest*ABC(2)/3,'k-.');
    plot(h_signrank*ABC(2)/3,'c-.');
    hline2(0.05);
    hold on
    xlim([20 70]);
    %vline2(30);
    %ylim([-abs(max([A1 A2])) abs(max([A1 A2]))])
    set(gcf,'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
    saveas(gcf,filename);
    close
end
end