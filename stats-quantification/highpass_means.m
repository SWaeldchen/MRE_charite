[mag_SH_hi_, means_SH_hi] = multisession_summary_stats(mag_SH_hipass, thr);
[mag_AF_hi_, means_AF_hi] = multisession_summary_stats(mag_AF_hipass, thr);
%[mag_FD_hi_, means_FD_hi] = multisession_summary_stats(mag_FD_hipass, thr);
%[mag_JG_hi_, means_JG_hi] = multisession_summary_stats(mag_JG_hipass, thr);

means_stack_hi = [means_SH_hi means_AF_hi]; % means_FD_hi];% means_JG_hi];
plot(means_stack_hi); title('reprod means_hi');
