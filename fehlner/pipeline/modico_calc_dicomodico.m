function modico_calc_dicomodico(RAWN_SUB, TOPUP_PARAM_PATH)

cd(RAWN_SUB);

% Topup => for rRL
do_applytopup(RAWN_SUB,'rRL',TOPUP_PARAM_PATH); % => modico 4
% Topup => for RL
do_applytopup(RAWN_SUB,'RL',TOPUP_PARAM_PATH); % => dico 2

end


function do_applytopup(RAWN_SUB,DATstr,TOPUP_PARAM_PATH)
cd(RAWN_SUB);
disp('Correcting distortions...');
system(['fsl5.0-applytopup --imain=' DATstr '_dyn_r_4D --inindex=1 --datain=' TOPUP_PARAM_PATH ' --topup=my_topup_results --method=jac --interp=spline --out=u' DATstr '_dyn_r_4D']);
system(['fsl5.0-applytopup --imain=' DATstr '_dyn_i_4D --inindex=1 --datain=' TOPUP_PARAM_PATH ' --topup=my_topup_results --method=jac --interp=spline --out=u' DATstr '_dyn_i_4D']);
     
end
