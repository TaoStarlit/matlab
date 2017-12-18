function [mu1_new, mu2_new, mu3_new, sigma1_new, sigma2_new, sigma3_new] = online_update_OnlinePL(mu1, mu2, mu3, sigma1, sigma2, sigma3, para)
%% i->1 j->2, k->3
%% notation
    kappa=getOpt(para, 'kappa', 1e-4);
    e1=exp(mu1);
    e2=exp(mu2);
    e3=exp(mu3);
    
    tri = e1+e2+e3;
    tri_sq = tri*tri;
    tri12 = e1+e2;
    tri13 = e1+e3;
    tri23 = e2+e3;
    delta23 = mu2+mu3;
% update mu_i, mu_j, mu_k
    mu1_new = mu1+sigma1*(tri23/tri);
    mu2_new = mu2+sigma2*(tri13/tri-(e2/tri23));
    mu3_new = mu3+sigma3*(-e3/tri-(e3/tri23));
% update sigma_i, sigma_j, sigma_k
    tmp1 = (-1)*e1*tri23/tri_sq;
    sigma1_new = sigma1*max(1+sigma1*tmp1, kappa);
    
    tmp2_a = (-1)*e2*tri13/tri_sq;
    tmp2_b = (-1)*exp(delta23)/(tri23*tri23);
    tmp2 = tmp2_a + tmp2_b;
    sigma2_new = sigma2*max(1+sigma2*tmp2, kappa);
    
    tmp3_a = (-1)*e3*tri12/tri_sq;
    tmp3_b = tmp2_b;
    tmp3 = tmp3_a + tmp3_b;
    sigma3_new = sigma3*max(1+sigma3*tmp3, kappa);
end