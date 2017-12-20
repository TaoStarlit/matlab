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
alpha_ini=[11,4,1,0.5];
%alpha_ini=[23,4,2,1];
alpha=repmat(alpha_ini,[n_anno,1]);

% taylor = 1 because we empoly taylor expansion
online_para=struct('c', 0.1, 'kappa', 1e-4, 'taylor', 1);
accuracy = [];

count=0;
for num = 1:1 % independent experiment
    for N = 1 : 1  % times run through the data  N= 5
       %% online Bayesian optimization for tuple (i,j,k) and worker K
        idx = randi(n_data,budget); % ranodm shuffer the data; ==> budget
        for r = 1 : budget % n_data
            i = data(idx(r), 2);
            j = data(idx(r), 3);
            k = data(idx(r), 4);
            K = data(idx(r), 1);
           [mu(i), mu(j), mu(k), sigma(i), sigma(j), sigma(k), alpha(K,1), alpha(K,2), alpha(K,3), alpha(K,4)]...
               = online_update_ROPAL(mu(i), mu(j), mu(k), sigma(i), sigma(j), sigma(k), alpha(K,1), alpha(K,2), alpha(K,3), alpha(K,4), online_para);

           %% Compute and print the Kendall's tau     ??????KL?????????????mu?????????
            dist = 0;
            for xx = 1:n_obj %???????§Ö????xx yy?????????????????¦Æ????
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

save(saveFile, 'accuracy')
