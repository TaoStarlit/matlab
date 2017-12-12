clc;
clear;
tic
load('data_amateur_5_4_3_2.mat');

n_anno = max(data(:,1));  % number of worker
n_obj  = max(max(data(:,2:end)));  % number of object
n_data = size(data,1);  % size of the data
Num = nchoosek(n_obj,2);
doc_diff = 1:1:n_obj;
%% set up initial parametmers 
% parameters for all objects
mu  =  zeros(n_obj,1);   % mean = 0
sigma  =  ones(n_obj,1);  % sigma = 1

% parameters for all workers
% alpha_ini  =  [8,6,4,3];
% alpha =  repmat(alpha_ini, n_anno, 1);
%load('alpha_amateur_ROPAL.mat')
load('rho_amateur.mat')
alpha = rho+0.01;
% taylor = 1 because we empoly taylor expansion
online_para=struct('c', 0.1, 'kappa', 1e-4, 'taylor', 1);
accuracy = [];
auc = [];
account = 1;
CNK = nchoosek(n_obj,2);
for num = 1 : 1 % independent experiment
    for N = 1 : 5  % times run through the data
        %% online Bayesian optimization for tuple (i,j,k) and worker K
        idx = randperm(n_data); % ranodm shuffer the data
        for r = 1: n_data
            i = data(idx(r), 2);
            j = data(idx(r), 3);
            k = data(idx(r), 4);
            K = data(idx(r), 1);
           [mu(i), mu(j), mu(k), sigma(i), sigma(j), sigma(k), alpha(K,1), alpha(K,2), alpha(K,3), alpha(K,4)]...
               = online_update_ROPAL(mu(i), mu(j), mu(k), sigma(i), sigma(j), sigma(k), alpha(K,1), alpha(K,2), alpha(K,3), alpha(K,4), online_para);
           acc = acc_calcu(doc_diff, mu, n_obj, CNK);
           auc = [auc,acc];
           if mod(account,1000) == 0 % every 100 iterations to display auc a time
              alpha = rho+0.01;
              fprintf('Iter=%d, AUC=%.4f\n', account, auc(account));
           end
           account = account +1;
        end
    end
    accuracy = [accuracy, mean(auc(end-100:end))];
end
toc