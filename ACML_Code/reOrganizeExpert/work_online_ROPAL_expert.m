clc;
clear;
tic
load('data_expert_23_4_2_1.mat');
saveFile = 'acc_expert_23_4_2_1_ROPAL.mat';

n_anno = max(data(:,1));  % number of worker
n_obj  = max(max(data(:,2:end)));  % number of object
n_data = size(data,1);  % size of the data
budget=5000;
theta = Score(:,2); % ground-true
%doc_diff = Score(:,2); %1:1:n_obj; ground-true


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
count=0;
CNK = nchoosek(n_obj,2);
for num = 1:1 % independent experiment
    for N = 1 : 1  % times run through the data  N= 5
       %% online Bayesian optimization for tuple (i,j,k) and worker K
        idx = randperm(budget); % ranodm shuffer the data; ==> budget
        for r = 1 : budget % n_data
            i = data(idx(r), 2);
            j = data(idx(r), 3);
            k = data(idx(r), 4);
            K = data(idx(r), 1);
% 搞笑这里从 很多变很少           
%            [mu(i), mu(j), sigma(i), sigma(j), alpha(K), beta(K)]...
%                 = online_update_OnlinePL(mu(i), mu(j), sigma(i), sigma(j), alpha(K), beta(K), online_para);
%            [mu(i), mu(k), sigma(i), sigma(k), alpha(K), beta(K)]...
%                 = online_update_OnlinePL(mu(i), mu(k), sigma(i), sigma(k), alpha(K), beta(K), online_para);
%            [mu(j), mu(k), sigma(j), sigma(j), alpha(K), beta(K)]...
%                 = online_update_OnlinePL(mu(j), mu(k), sigma(j), sigma(k), alpha(K), beta(K), online_para);
            
            [mu(i), mu(j), mu(k), sigma(i), sigma(j), sigma(k)] = online_update_OnlinePL(mu(i), mu(j), mu(k), sigma(i), sigma(j), sigma(k), online_para);
          
            
%            acc = acc_calcu(doc_diff, mu, n_obj, CNK);
%            auc = [auc,acc];
%            if mod(account,5000) == 0 % every 100 iterations to display auc a time
%                 fprintf('Iter=%d, AUC=%.4f\n', account, auc(account));
%            end
%            account =account+1;
           %% Compute and print the Kendall's tau     ??????KL?????????????mu?????????
            dist = 0;
            for xx = 1:n_obj %???????е????xx yy?????????????????ζ????
                for yy = xx+1:n_obj
                    if (mu(xx) - mu(yy))*(theta(xx) - theta(yy)) > 0 %?????mu?????????????????????????1
                        dist = dist + 1;
                    end
                end
            end
            acc = 2 * dist / (n_obj * (n_obj-1));
            count=count+1;
            accuracy(count)=acc;
            if(mod(count,8)==0)
                fprintf('iter:%06d, accuracy:%0.3f\n',count,accuracy(count));  
            end
           
           
        end
    end
    %accuracy = [accuracy, mean(auc(end-100:end))];
end
toc
%acc = auc;
save(saveFile, 'acc')
