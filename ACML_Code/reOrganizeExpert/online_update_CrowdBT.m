function [mu1_new, mu2_new, sigma1_new, sigma2_new, alpha_new, beta_new] = online_update_CrowdBT(mu1, mu2, sigma1, sigma2, alpha, beta, para)

    kappa=getOpt(para, 'kappa', 1e-4);
    taylor=getOpt(para, 'taylor', false);

    e1 = exp(mu1);
    e2 = exp(mu2);
    e12 = e1+e2;
    ae1 = alpha*e1;
    be2 = beta*e2;
    abe12 = ae1+be2;
    
    tmp1 = ae1/abe12-e1/e12;
    mu1_new = mu1+sigma1*tmp1;
    mu2_new = mu2-sigma2*tmp1;

    tmp2 = (ae1*be2/(abe12^2)-e1*e2/(e12^2));
    sigma1_new = sigma1*max(1+sigma1*tmp2, kappa);
    sigma2_new = sigma2*max(1+sigma2*tmp2, kappa);
    
    if taylor
        C1 = max(e1/e12 + 1/2*(sigma1+sigma2) * (e1*e2*(e2-e1)/(e12^3)), kappa);
        C2 = max(e2/e12 + 1/2*(sigma1+sigma2) * (e1*e2*(e1-e2)/(e12^3)), kappa);
    end
    C1 = C1/(C1+C2);
    C2 = C2/(C1+C2);
    
    C=(C1*alpha+C2*beta)/(alpha+beta);
    m=(C1*(alpha+1)+C2*beta)*alpha/(C*(alpha+beta+1)*(alpha+beta));
    v=(C1*(alpha+2)+C2*beta)*(alpha+1)*alpha/(C*(alpha+beta+2)*(alpha+beta+1)*(alpha+beta));
     
    alpha_new = (m-v)*m/(v-m^2);
    beta_new = (m-v)*(1-m)/(v-m^2);
end

