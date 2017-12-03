%% matlab index 从1算起的；循环区间是全闭区间1:10；r是索引，一个正整数，你要处理第一个
%% 1- 9
%%46-54
%%91-99

n_data=size(data,1);
gamma=getOpt(para,'gamma',0);  
% 重新初始化mu1 sigma1 
mu(1)=0;
sigma(1)=0;
alpha(1)=4;
beta(1)=1;

% 重新初始化
% 参照init_score,   online_update这里
[mu1_new, mu2_new, sigma1_new, sigma2_new, alpha_new, beta_new, KL_o, KL_a, win_prob]=online_update(mu(1),mu(1), sigma(1), sigma(1), alpha(1), beta(1), para);
score=(KL_o+gamma*KL_a).*ones(n_data,1);        
tmp=struct('mu1', mu1_new, 'mu2', mu2_new', 'sigma1', sigma1_new, 'sigma2', sigma2_new, 'alpha', alpha_new, 'beta', beta_new);
% 清零 try_result
for w = 1:8 % 1:8
    for comb = 1:9
        r = w*45 + comb
        try_result{r,1}=tmp;
        try_result{r,2}=tmp;
    end
end
%产生与object1有关的几个数据
%学习吧
%打印出结果

theta(1)=%0.02 到 0.2
end
