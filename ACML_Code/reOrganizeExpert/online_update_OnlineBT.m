function [mu1_new, mu2_new, sigma1_new, sigma2_new] = online_update_OnlineBT(mu1, mu2, sigma1, sigma2, para)

    kappa=getOpt(para, 'kappa', 1e-4);
    e1=exp(mu1);
    e2=exp(mu2);
    tri12=e1+e2;
    tri12_sq = tri12*tri12;
    delta12=mu1+mu2;
    % update mu1 and mu2
    tmp1=e2/tri12;
    mu1_new=mu1+sigma1*tmp1;
    mu2_new=mu2-sigma2*tmp1;

    % update sigma1 and sigma2
    tmp2=(-1)*exp(delta12)/tri12_sq;
    sigma1_new = sigma1*max(1+sigma1*tmp2, kappa);
    sigma2_new = sigma2*max(1+sigma2*tmp2, kappa);

end