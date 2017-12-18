function [mu1_new, mu2_new, mu3_new, sigma1_new, sigma2_new, sigma3_new,...
   alpha0_new, alpha1_new, alpha2_new, alpha3_new]=online_update_ROPAL(mu1, mu2, mu3, sigma1, sigma2, sigma3, alpha0, alpha1, alpha2, alpha3, para)

%% i->1 j->2, k->3
% [mu(i), mu(j), mu(k), sigma(i), sigma(j), sigma(k), alpha0(K), alpha1(K), alpha2(K), alpha3(K)]...
%        =online_update_clique(mu(i), mu(j), mu(k), sigma(i), sigma(j), sigma(k), alpha0(K), alpha1(K), alpha2(K), alpha3(K), online_para);
%% notation
    kappa=getOpt(para, 'kappa', 1e-4);
    taylor=getOpt(para, 'taylor', false);
    
    e1=exp(mu1);
    e2=exp(mu2);
    e3=exp(mu3);
    
    tri = e1+e2+e3;
    tri12 = e1+e2;
    tri13 = e1+e3;
    tri23 = e2+e3;
    
    delta12 = mu1+mu2;
    delta13 = mu1+mu3;
    delta23 = mu2+mu3;
    
    A1 = alpha0*exp(delta12)*tri12*tri13;
    A2 = alpha1*exp(delta13)*tri12*tri13;
    A = A1+A2;
    
    B1 = alpha1*exp(delta12)*tri12*tri23;
    B2 = alpha2*exp(delta23)*tri12*tri23;
    B = B1+B2;
    
    C1 = alpha2*exp(delta13)*tri13*tri23;
    C2 = alpha3*exp(delta23)*tri13*tri23;
    C = C1+C2;
    
    S = A+B+C;
    
%% update Si, Sj, Sk 
% update mu_i, mu_j, mu_k
    mu1_new = mu1+sigma1*(A/S-(e1/tri));
    mu2_new = mu2+sigma2*(B/S-(e2/tri));
    mu3_new = mu3+sigma3*(C/S-(e3/tri));
% update sigma_i, sigma_j, sigma_k
    S_sq = S*S;
    tri_sq = tri*tri;
    
    tmp1_a = A*(B2+C2+(e1/tri12)*C+(e1/tri13)*B);
    tmp1_b = e1*tri23;
    tmp1 = (tmp1_a/S_sq)-(tmp1_b/tri_sq);
    sigma1_new = sigma1*max(1+sigma1*tmp1, kappa);
    
    tmp2_a = B*(A2+C1+(e2/tri23)*A+(e2/tri12)*C);
    tmp2_b = e2*tri13;
    tmp2 = (tmp2_a/S_sq)-(tmp2_b/tri_sq); 
    sigma2_new = sigma2*max(1+sigma2*tmp2, kappa);
    
    tmp3_a = C*(A1+B1+(e3/tri23)*A+(e3/tri13)*B);
    tmp3_b = e3*tri12;
    tmp3 = (tmp3_a/S_sq)-(tmp3_b/tri_sq);
    sigma3_new = sigma3*max(1+sigma3*tmp3, kappa);
    
%% update eta_k     
    if taylor
        R0 = expected_probability(mu1, mu2, mu3, sigma1, sigma2, sigma3);
        R1 = expected_probability(mu1, mu3, mu2, sigma1, sigma3, sigma2) + expected_probability(mu2, mu1, mu3, sigma2, sigma1, sigma3);
        R2 = expected_probability(mu2, mu3, mu1, sigma2, sigma3, sigma1) + expected_probability(mu3, mu1, mu2, sigma3, sigma1, sigma2);
        R3 = expected_probability(mu3, mu2, mu1, sigma3, sigma2, sigma1);
    end
    % normalize R0, R1, R2, R3
    R_all = R0+R1+R2+R3;
    alpha_all = alpha0+alpha1+alpha2+alpha3;
    R0 = R0/R_all;
    R1 = R1/R_all;
    R2 = R2/R_all;
    R3 = R3/R_all;
    R = (alpha0/alpha_all)*R0+(alpha1/alpha_all)*R1+(alpha2/alpha_all)*R2+(alpha3/alpha_all)*R3;
    
    alpha_R = R0*alpha0+R1*alpha1+R2*alpha2+R3*alpha3;
    div_1 = R*(alpha_all+1)*alpha_all;
    div_2 = R*(alpha_all+2)*(alpha_all+1)*alpha_all;
    m0= alpha0*(alpha_R+R0)/div_1;
    v0= alpha0*(alpha0+1)*(alpha_R+2*R0)/div_2;
    m1= alpha1*(alpha_R+R1)/div_1;
    v1= alpha1*(alpha1+1)*(alpha_R+2*R1)/div_2;
    m2= alpha2*(alpha_R+R2)/div_1;
    v2= alpha2*(alpha2+1)*(alpha_R+2*R2)/div_2;
    m3= alpha3*(alpha_R+R3)/div_1;
    v3= alpha3*(alpha3+1)*(alpha_R+2*R3)/div_2;

    alpha0_new=(m0-v0)*m0/(v0-m0^2);
    alpha1_new=(m1-v1)*m1/(v1-m1^2);
    alpha2_new=(m2-v2)*m2/(v2-m2^2);
    alpha3_new=(m3-v3)*m3/(v3-m3^2);
end

function R_abc = expected_probability(mu_a, mu_b, mu_c, sigma_a, sigma_b, sigma_c)
    e_a=exp(mu_a);
    e_b=exp(mu_b);
    e_c=exp(mu_c);
    
    tri = e_a+e_b+e_c;
    tri_sq = tri*tri;
    tri_cub = tri*tri*tri;
    tri_ac = e_a+e_c;
    tri_bc = e_b+e_c;
    
    delta = mu_a+mu_b+mu_c;
    delta_ab = mu_a+mu_b;

    tmp1 = (e_a*e_b)/(tri*tri_bc);
    tmp2 = 0.5*sigma_a*(exp(delta_ab)*(tri-2*e_a)/tri_cub);
    
    tmp3_a = (exp(delta_ab)*tri_ac*(e_c*tri-2*e_b*tri_bc))/(tri_cub*tri_bc*tri_bc);
    tmp3_b = (exp(delta_ab + mu_b)*(2*e_c*tri - e_b*tri_bc))/(tri_sq*tri_bc*tri_bc*tri_bc);
    tmp3 = 0.5*sigma_b*(tmp3_a - tmp3_b);
    
    tmp4_a = ((2*exp(delta)*e_c)/(tri*tri_bc))*(1/tri_sq + 1/(tri_bc*tri_bc));
    tmp4_b = (exp(delta)*(e_a + 2*e_b))/(tri_sq*tri_bc*tri_bc);
    tmp4 = 0.5*sigma_c*(tmp4_a - tmp4_b);
    
    R_abc = tmp1 + tmp2 + tmp3 + tmp4;
end