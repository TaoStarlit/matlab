clc;
clear;
tic
load('data_expert_23_4_2_1.mat');

n_anno = max(data(:,1));  % number of worker
n_obj  = max(max(data(:,2:end)));  % number of object
n_data = size(data,1);  % size of the data

doc_diff = 1:1:n_obj;
%% set up initial parametmers 
% parameters for all objects
mu  =  zeros(n_obj,1);   % mean = 0
sigma  =  ones(n_obj,1);  % sigma = 1

% parameters for all workers
alpha0  =  8;
beta0   =  1;
alpha   =  alpha0.*ones(n_anno,1);
beta    =  beta0.*ones(n_anno,1);

% taylor = 1 because we empoly taylor expansion
online_para=struct('c', 0.1, 'kappa', 1e-4, 'taylor', 1);
accuracy = [];
auc = [];
account = 1;
CNK = nchoosek(n_obj,2);
for num = 1:1 % independent experiment
    for N = 1 : 5  % times run through the data
        %% online Bayesian optimization for tuple (i,j,k) and worker K
        idx = randperm(n_data); % ranodm shuffer the data
        for r = 1 : n_data
            i = data(idx(r), 2);
            j = data(idx(r), 3);
            k = data(idx(r), 4);
            K = data(idx(r), 1);
           [mu(i), mu(j), sigma(i), sigma(j), alpha(K), beta(K)]...
                = online_update_CrowdBT(mu(i), mu(j), sigma(i), sigma(j), alpha(K), beta(K), online_para);
           [mu(i), mu(k), sigma(i), sigma(k), alpha(K), beta(K)]...
                = online_update_CrowdBT(mu(i), mu(k), sigma(i), sigma(k), alpha(K), beta(K), online_para);
           [mu(j), mu(k), sigma(j), sigma(j), alpha(K), beta(K)]...
                = online_update_CrowdBT(mu(j), mu(k), sigma(j), sigma(k), alpha(K), beta(K), online_para);
           acc = acc_calcu(doc_diff, mu, n_obj, CNK);
           auc = [auc,acc];
           if mod(account,5000) == 0 % every 100 iterations to display auc a time
                fprintf('Iter=%d, AUC=%.4f\n', account, auc(account));
           end
           account =account+1;
        end
    end
    accuracy = [accuracy, mean(auc(end-100:end))];
end
toc
acc = auc;
save acc_expert(23)_CrowdBT.mat acc