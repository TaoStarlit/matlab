%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Simulation drive file
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Basic inputs
clear 

n_anno = 8;  % number of workers
n_obj = 10;   % number of items
budget = 50;      % total available budget   预算，准备迭代的次数，越大通常就越准，初始是30
trials = 3;  % number of independent trials to run
u = 4; % Beta(u,v) is the generating distribution of workers' reliability
v = 1;

alpha0 = 4; % Beta(alpha0,beta0) is the prior of workers' reliability
beta0 = 1;
gamma = 1; % exploration-exploitaion tradeoff    for active learning, we can delete it

%% Test

record = zeros(trials,budget); % record of ranking accuracy

for tr = 1:trials % all dependent
    
    theta = drchrnd(ones(1,n_obj),1); % generate items    dirchelet 分布产生
    rho = betarnd(u,v,1,n_anno); % generate workers     beta分布产生       the quanlity of workers
    
    % create data
    all_comb = combnk(1:n_obj, 2);   %All combinations of the N elements in V taken K at a time，  组合
    [m,~] = size(all_comb); % 10*9/(1*2)    m = 45
    data = zeros(m*n_anno,3); % 45 * 8 360组
    for w = 1:n_anno
        before = (w-1)*m+1;   %for each annotator, index from 0,  m the number of comb
        after = w*m;
        data(before:after,1) = w; % 第一列是worker编号，二三列是这个组合
        data(before:after,2:3) = all_comb;
    end %问题是只有组合没有大小表示呀
    
    % initial parameters
    mu = zeros(n_obj,1); % 10 objects, the annotaion of each object obeys normal distribution   初始化先验参数
    sigma = ones(n_obj,1);
    alpha = alpha0 .* ones(n_anno,1);
    beta = beta0 .* ones(n_anno,1);
    
    active_para = struct('c', 0.1, 'kappa', 1e-4, 'taylor', 0, 'gamma', gamma, 'calc_iter', 1, ...
                        'sel_method', 'greedy', 'anno_threshold', 1e-4); % option augument
    % learning to obtain the parameters
    [mu, sigma, alpha, beta, accuracy, hist]...
        = active_learning(data, budget, mu, sigma, alpha, beta, theta, rho, trials, active_para);
    
    record(tr,:) = accuracy;

end

%% Save simulation result

averaged = mean(record);
save(['./active_', active_para.sel_method,'_',num2str(n_anno),'_workers_',num2str(n_obj),'_items.mat'],...
    'averaged');
