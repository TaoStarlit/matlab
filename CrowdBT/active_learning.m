%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Crowd-BT Algorithm
%%%%%%%%%%%%%%%%%%%%%%%%%%%
% data 360 K*N(�������)= 8*(10*9/2/1)ò��û��ʵ�����ݣ�ֻ�ж�Ӧ��ϵ��  data �ֶ�1��worker;  �ֶ�2��3����Ʒ��ŵ���ϣ�ÿ��worker��ȫһ�����ظ���
% score 360 
% try result �����м����� ÿ�����������ȫ���� sigma mu 1 2,  alpha, beta

% ����������� (Dir����8����ÿ��worker��Ӧһ��alpha,beta,���ư����ֵı���)alpha, beta   (Gaussian ����10��)mu sigma  
% ���Ǳ����ֲ������ģ������ߵ�����  eg 0.78 	0.83 	0.26 	0.93 	0.85 	0.89 	0.99 	0.99 
% ����dirchelet�ֲ������ģ�ÿ����Ʒ/��Ŀ�ķ���   eg 0.047 	0.013 	0.063 	0.066 	0.410 	0.067 	0.050 	0.125 	0.149 	0.011 
function [mu, sigma, alpha, beta, accuracy, hist]...
    = active_learning(data, budget, mu, sigma, alpha, beta, theta, rho, trial, para)
    % para sets the parameters of the algorithm
    gamma = getOpt(para,'gamma', 0); % balances exploration-exploitation        coefficient of balance
    calc_iter = getOpt(para,'calc_iter', 100);  % calculation of iteration  100  why?
    anno_threshold = getOpt(para,'anno_threshold', 1e-4);   % ??
    verbose = getOpt(para,'verbose', true);
    sel_method = getOpt(para,'sel_method', 'greedy');

    n_data = size(data,1);% C(10��,2) * 8λ
    n_obj = length(mu);% 10��
    accuracy = zeros(1,budget);
    
    [score, try_result] = init_score(data, mu, sigma, alpha, beta, para);%���ݴ����������  360����������ʾʲô�� 360�Խ����ÿ��������涼��mu sigma 1,2   alpha, beta�� ���������������ϸ��£�

    hist = struct('seq', zeros(n_obj,1), 'score', ones(n_obj,1));
    candidate = true(n_data,1);%candidateҲȫ����1
    % ����360��score��ȫһ���� 72��try_resultҲ����ȫһ��         mu����0��sigma����1�� alpha��4��beta��1
    %�����Ƕ���ṹ����Ϊʲôû�п�����������ֵ��
    for iter = 1:budget %��׼��online�㼸��, ׼�����뼸������
        
       %% Select the highest score --- greedy algorithm    ÿ�β���һ��r��r��360�� k�� i��j��ϣ���ѡһ��
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
        split = rho(k) * theta(i) / (theta(i) + theta(j)) + (1 - rho(k)) * theta(j) / (theta(i) + theta(j));%����ǣ�ʵ�ʷ����������������ó��������ǿ�ѧ����
        if rand > split % i,j�ߵ�һ�£�  rand�Ҳ������壬����֣�  ��������������������ݣ�i�Ƿ��j��Ҫ���� Ԥ��� ���������ʺ�Ŀ��ķ���
            i = data(r,3);
            j = data(r,2);
        end
        % �޸ĵ�ʱ���ص��������ˣ���  �򵥾���һ��power �� RT�� ��������RT����  RT��������theta��
        % power���û��������֣�Ȼ�������Աȣ������ͬ��RT��Ҫ�ߵ���
      
        % �������� ������ mu sigma
        mu(i) = try_result{r,1}.mu1;
        mu(j) = try_result{r,1}.mu2;
        sigma(i) = try_result{r,1}.sigma1;
        sigma(j) = try_result{r,1}.sigma2;
        
       %% Update the new score and try_result    ���list���� 450���к͵�ǰ��Ԫ�� k i j�������������ȣ����һ�û��ѡ�е�       
        if abs(try_result{r,1}.alpha-alpha(k))<anno_threshold && abs(try_result{r,1}.beta-beta(k)) < anno_threshold
            update_list = find( ((data(:,2)==i) | (data(:,3)==j) | (data(:,2)==j) | (data(:,3)==i)) & candidate);
        else
            update_list = find( (data(:,1) ==k | (data(:,2)==i) | (data(:,3)==j)| (data(:,2)==j) | (data(:,3)==i)) & candidate);
        end
        % �������� ������ alpha beta
        alpha(k) = try_result{r,1}.alpha;
        beta(k) = try_result{r,1}.beta;
        %����ĵط����� try result 1 try result 2,Ӧ���Ǻ���ֲ�������Ҫ��moment match����
        for rr = 1:length(update_list) %ĳһ�ε�����������135���������� 8 * 45 = 360�е� 135���� ��130+  --> 150+  ֮�䲨��
            r = update_list(rr);
            i = data(r,2);
            j = data(r,3);
            k = data(r,1);%�����������������֤  �������try_result����         ����update online���ֻ�� i j �ߵ�
            [try_result{r,1}.mu1, try_result{r,1}.mu2, try_result{r,1}.sigma1, try_result{r,1}.simga2, try_result{r,1}.alpha,  try_result{r,1}.beta,...
                KL_win_o, KL_win_a, win_prob]=online_update(mu(i), mu(j), sigma(i), sigma(j), alpha(k), beta(k), para);
            [try_result{r,2}.mu1, try_result{r,2}.mu2, try_result{r,2}.sigma1, try_result{r,2}.simga2, try_result{r,2}.alpha,  try_result{r,2}.beta,...
                KL_lose_o, KL_lose_a, lose_prob]=online_update(mu(j), mu(i), sigma(j), sigma(i), alpha(k), beta(k), para);
            score(r) = win_prob*(KL_win_o+gamma*KL_win_a)+lose_prob*(KL_lose_o+gamma*KL_lose_a);
        end
        
        %% Compute and print the Kendall's tau     ׼ȷ����KL�������㣬�����mu��ʵ�ʵķ���
        dist = 0;
        for xx = 1:n_obj %�������е����xx yy����Ʒ����������ÿ�ζ���ͬ
            for yy = xx+1:n_obj
                if (mu(xx) - mu(yy))*(theta(xx) - theta(yy)) > 0 %�����mu��ϵ����ʵ�ʷ����Ĳ�ͬ��������1
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
    
    
    %��һ���µ�
end