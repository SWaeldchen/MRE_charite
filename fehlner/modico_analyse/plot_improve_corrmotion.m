function res = plot_improve_corrmotion(C,mFD,id,txtylabel,prestr)  

% [p_sign_12,h_sign_12]=signrank(C(1,:),C(2,:));
    % [p_sign_34,h_sign_34]=signrank(C(3,:),C(4,:));
    [h_ttest_12,p_ttest_12] = ttest(C(1,:),C(2,:));
    [h_ttest_34,p_ttest_34] = ttest(C(3,:),C(4,:));
    %figure,
    subplot(2,2,[1 3])
    errorbar(mean(C,2),std(C,[],2),'k.-'),...
        title(['o/m(p='  sprintf('%0.2g',p_ttest_12) ...
        ') d/md(p='  sprintf('%0.2g',p_ttest_34) ')']);
    set(gca,'XTICK',1:4,'Xticklabel',{'o','m','d','md'});
    % % Correlation with motion
    % figure
    % D = squeeze(B(:,1,:)-B(:,2,:)); % PSF_orig vs. PSF_moco
    % subplot(121), plot(mFD,mean(D,1),'.'), ylabel('PSF FWHM decrease [mm] for orig->moco'), xlabel('Position variability [mm]')
    % [R,P]=corrcoef(mean(D,1),mFD);title(['R = ' num2str(R(2)) ' with P =' num2str(P(2))])
    
    Do_m = squeeze(C(1,:)-C(2,:)); % PSF_orig vs. PSF_moco    
    Dd_md = squeeze(C(3,:)-C(4,:)); % PSF_dico vs. PSF_modico
    
    [Rom,Pom] = corrcoef(mFD,Do_m);
    [Rdmd,Pdmd] = corrcoef(mFD,Dd_md);
    
    subplot(2,2,2);       
    %plot(mFD,Do_m,'o');
    scatter(mFD,Do_m,'o');
    lsline;
    xlim([0 2]); %, ylim([-3 3]);
    xlabel('Position variability [mm]');
    ylabel(txtylabel);
    %title(['R = ' num2str(Rom(2)) ', P = ' num2str(Pom(2))]);
    title(['o/m r = ' sprintf('%0.2g',Rom(2)) ', p = ' sprintf('%0.2g',Pom(2))]);    
    
    subplot(2,2,4);
    
    %plot(mFD,Dd_md,'o');
    scatter(mFD,Dd_md,'o');
    lsline;
    xlim([0 2]); 
    xlabel('Position variability [mm]');
    ylabel(txtylabel);
    %title(['R = ' num2str(Rdmd(2)) ', P = ' num2str(Pdmd(2))]);    
    title(['d/md r = ' sprintf('%0.2g',Rdmd(2)) ', p = ' sprintf('%0.2g',Pdmd(2))]);
    
    disp(['FWHM reduces by (' num2str(mean(Do_m)) ' +- ' num2str(std(Do_m)) ') mm from orig to moco']);    
    disp(['FWHM reduces by (' num2str(mean(Dd_md)) ' +- ' num2str(std(Dd_md)) ') mm from dico to modico']);
    disp(['Position variability (' num2str(mean(mFD)) ' +- ' num2str(std(mFD)) ')']);
    
    suplabel([txtylabel '-' id '-' prestr]); %'Interpreter', 'none');

    
    res.p_om = p_ttest_12;
    res.p_dmd = p_ttest_34;
    
    res.mean_Do_m = mean(Do_m);
    res.std_Do_m = std(Do_m);    
    res.mean_Dd_md = mean(Dd_md);
    res.std_Dd_md = std(Dd_md);
    
    res.p_om_corrposv = Pom(2);
    res.r_om_corrposv = Rom(2);
    
    res.p_dmd_corrposv = Pdmd(2);
    res.r_dmd_corrposv = Rdmd(2);
    
    
end