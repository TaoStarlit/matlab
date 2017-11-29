%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Crowd-BT Algorithm
%%%%%%%%%%%%%%%%%%%%%%%%%%%
% data 360 K*N(两两组合)= 8*(10*9/2/1)貌似没有实际内容，只有对应关系。  data 字段1，worker;  字段2，3，物品编号的组合（每个worker完全一样的重复）
% score 360 
% try result 两对中间结果， 每个结果，里面全都是 sigma mu 1 2,  alpha, beta

% 先验参数，就 (Dir产生8个，每个worker对应一个alpha,beta,类似棒球手的表现)alpha, beta   (Gaussian 产生10个)mu sigma  
% ρ是贝塔分布产生的，评论者的素质  eg 0.78 	0.83 	0.26 	0.93 	0.85 	0.89 	0.99 	0.99 
% θ是dirchelet分布产生的，每个物品/项目的分数   eg 0.047 	0.013 	0.063 	0.066 	0.410 	0.067 	0.050 	0.125 	0.149 	0.011 
function [mu, sigma, alpha, beta, accuracy, hist]...
    = active_learning(data, budget, mu, sigma, alpha, beta, theta, rho, trial, para)
    % para sets the parameters of the algorithm
    gamma = getOpt(para,'gamma', 0); % balances exploration-exploitation        coefficient of balance
    calc_iter = getOpt(para,'calc_iter', 100);  % calculation of iteration  100  why?
    anno_threshold = getOpt(para,'anno_threshold', 1e-4);   % ??
    verbose = getOpt(para,'verbose', true);
    sel_method = getOpt(para,'sel_method', 'greedy');

    n_data = size(data,1);% C(10个,2) * 8位
    n_obj = length(mu);% 10个
    accuracy = zeros(1,budget);
    
    [score, try_result] = init_score(data, mu, sigma, alpha, beta, para);%数据从这里产生了  360个分数（表示什么） 360对结果（每个结果里面都是mu sigma 1,2   alpha, beta， 六个超参数，不断更新）

    hist = struct('seq', zeros(n_obj,1), 'score', ones(n_obj,1));
    candidate = true(n_data,1);%candidate也全部是1
    % 这里360个score完全一样， 72个try_result也是完全一样         mu都是0，sigma都是1， alpha是4，beta是1
    %上面是定义结构，但为什么没有看到真正的数值呢
    for iter = 1:budget %你准备online算几次, 准备输入几个样本
        
       %% Select the highest score --- greedy algorithm    每次产生一个r，r是360中 k， i，j组合，挑选一种
        if strcmp(sel_method, 'greedy')
            [hist.score(iter)] = max(score);            
            idx = find(score==hist.score(iter));
            if length(idx) == 1
                r = idx;
            else                
                r = idx(randsample(length(idx),1));
            end          
        elseif strcmp(sel_method, 'multinomial')
            r = find(mnrnd(1,score./sum(score)));
        elseif strcmp(sel_method, 'random')
            r = randsample(find(candidate),1);
        end
            
        hist.seq(iter)=r;      
        candidate(r)=false;
        score(r)=0;        
        
       %% Reveal the results i>_k j  and update parameters 
        i = data(r, 2);
        j = data(r, 3);
        k = data(r, 1);
        % law of total probability    P(oi  >k  oj)
        split = rho(k) * theta(i) / (theta(i) + theta(j)) + (1 - rho(k)) * theta(j) / (theta(i) + theta(j));%奇怪是，实际分数，可以这样子拿出来，不是靠学的吗？
        if rand > split % i,j颠倒一下，  rand找不到定义，好奇怪！  这里才是真正的输入数据，i是否比j大，要经过 预设的 评论者素质和目标的分数
            i = data(r,3);
            j = data(r,2);
        end
        % 修改的时候，重点是这里了！！  简单经过一个power 和 RT， 甚至不用RT？？  RT是真正的theta，
        % power是用户给的评分，然后做出对比，如果不同于RT就要颠倒？
      
        % 更新先验 超参数 mu sigma
        mu(i) = try_result{r,1}.mu1;
        mu(j) = try_result{r,1}.mu2;
        sigma(i) = try_result{r,1}.sigma1;
        sigma(j) = try_result{r,1}.sigma2;
        
       %% Update the new score and try_result    这个list就是 450所有和当前三元组 k i j有中任意相等相等，而且还没别选中的       
        if abs(try_result{r,1}.alpha-alpha(k))<anno_threshold && abs(try_result{r,1}.beta-beta(k)) < anno_threshold
            update_list = find( ((data(:,2)==i) | (data(:,3)==j) | (data(:,2)==j) | (data(:,3)==i)) & candidate);
        else
            update_list = find( (data(:,1) ==k | (data(:,2)==i) | (data(:,3)==j)| (data(:,2)==j) | (data(:,3)==i)) & candidate);
        end
        % 更新先验 超参数 alpha beta
        alpha(k) = try_result{r,1}.alpha;
        beta(k) = try_result{r,1}.beta;
        %奇妙的地方在于 try result 1 try result 2,应该是后验分布，而且要用moment match来做
        for rr = 1:length(update_list) %某一次迭代，这里是135个，就是那 8 * 45 = 360中的 135个， 在130+  --> 150+  之间波动
            r = update_list(rr);
            i = data(r,2);
            j = data(r,3);
            k = data(r,1);%用先验来计算出后验证  后验放在try_result里面         两个update online差别只是 i j 颠倒
            [try_result{r,1}.mu1, try_result{r,1}.mu2, try_result{r,1}.sigma1, try_result{r,1}.simga2, try_result{r,1}.alpha,  try_result{r,1}.beta,...
                KL_win_o, KL_win_a, win_prob]=online_update(mu(i), mu(j), sigma(i), sigma(j), alpha(k), beta(k), para);
            [try_result{r,2}.mu1, try_result{r,2}.mu2, try_result{r,2}.sigma1, try_result{r,2}.simga2, try_result{r,2}.alpha,  try_result{r,2}.beta,...
                KL_lose_o, KL_lose_a, lose_prob]=online_update(mu(j), mu(i), sigma(j), sigma(i), alpha(k), beta(k), para);
            score(r) = win_prob*(KL_win_o+gamma*KL_win_a)+lose_prob*(KL_lose_o+gamma*KL_lose_a);
        end
        
        %% Compute and print the Kendall's tau     准确率用KL距离来算，估算的mu和实际的分数
        dist = 0;
        for xx = 1:n_obj %遍历所有的组合xx yy是物品的索引而且每次都不同
            for yy = xx+1:n_obj
                if (mu(xx) - mu(yy))*(theta(xx) - theta(yy)) > 0 %估算的mu关系，与实际分数的不同，则距离加1
                    dist = dist + 1;
                end
            end
        end
        accuracy(iter) = 2 * dist / (n_obj * (n_obj-1));

    end
            
    fprintf('Trial = %d, Iter = %d, Accuracy = %f \n', trial, iter, accuracy(iter));
    fprintf('\n mu:\n')
    fprintf(1, '%0.3f ', mu)
    fprintf('\n theta:\n')
    fprintf(1, '%0.3f ', theta)
    fprintf('\n\n\n')
    
    
    %来一个新的
end