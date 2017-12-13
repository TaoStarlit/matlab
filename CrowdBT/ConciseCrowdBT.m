%% simulated data
load('data_expert_23_4_2_1.mat');
theta = Score(:,2); % ground-true
budget = 5000;
saveFile = 'simulated result.mat'
saveFig='simulated result.fig'
savePng= 'simulated result.png'


%% simulated data   BabyFaceData
% load('./babyfaceData/BabyFacePreference.mat');
% data=D;
% theta = [9 6 15 18 14 3  1 2 16 8 4 17  11 10 7 5 12 13];% the uainmous preference of myself, not very accurate
% what we get Rank:09 06 03 15 18 04 12 14 16 10 01 11 02 08 05 17 07 13  sometimes, the accuracy can up to 0.64

% theta = [09 06 15 18 03 04  11 02 16 08 01 14  05 10 12 17 07 13]; % copy from the result, the accuracy is always lower than 0.6
% theta = [09 06 03 15 18 04 05 10 12 14 02 08 11 16 17 01 07 13];
% what we get Rank:09 06 15 03 18 04 11 10 02 05 12 16 01 08 17 14 07 13
% what we get Rank:09 06 03 15 18 04 05 11 12 16 08 02 10 01 14 17 07 13
% what we get Rank:09 06 03 18 15 04 10 11 08 12 05 16 02 14 01 17 13 07 
% what we get Rank:09 06 03 15 18 04 05 10 12 14 02 08 11 16 17 01 07 13 

% what we get Rank:09 06 03 18 15 11 04 12 10 14 05 08 16 02 01 17 07 13 
% what we get Rank:09 06 15 03 18 05 04 10 12 14 11 02 01 08 16 17 07 13
% what we get Rank:09 06 03 15 04 18 05 11 10 16 08 14 12 02 01 17 13 07 


n_anno = max(data(:,1));  % number of worker
n_obj  = max(max(data(:,2:end)));  % number of object
n_data = size(data,1);  % size of the data


%% set up initial parametmers 
mu  =  zeros(n_obj,1);   % mean = 0
sigma  =  ones(n_obj,1);  % sigma = 1

% parameters for all workers
alpha0  =  8;
beta0   =  1;
alpha   =  alpha0.*ones(n_anno,1);
beta    =  beta0.*ones(n_anno,1);

% taylor = 1 because we empoly taylor expansion;   if we don't?
online_para=struct('c', 0.1, 'kappa', 1e-4, 'taylor', 1);
accuracy = [];
auc = [];
account = 1;
CNK = nchoosek(n_obj,2);
for num = 1:1 % independent experiment
    count=0;
    for N = 1 : 1  % times run through the data  N= 5
       %% online Bayesian optimization for tuple (i,j,k) and worker K
        %idx = randperm(n_data); % ranodm shuffer the data  the origin
        idx = randsample(n_data,budget);% mine
        for r = 1 : budget
            i = data(idx(r), 2);
            j = data(idx(r), 3);
            k = data(idx(r), 4);
            K = data(idx(r), 1);
           [mu(i), mu(j), sigma(i), sigma(j), alpha(K), beta(K),KL_win_o, KL_win_a, win_prob]...
                = online_update(mu(i), mu(j), sigma(i), sigma(j), alpha(K), beta(K), online_para);
           [mu(i), mu(k), sigma(i), sigma(k), alpha(K), beta(K),KL_win_o, KL_win_a, win_prob]...
                = online_update(mu(i), mu(k), sigma(i), sigma(k), alpha(K), beta(K), online_para);
           [mu(j), mu(k), sigma(j), sigma(j), alpha(K), beta(K),KL_win_o, KL_win_a, win_prob]...
                = online_update(mu(j), mu(k), sigma(j), sigma(k), alpha(K), beta(K), online_para);
%            acc = acc_calcu(doc_diff, mu, n_obj, CNK);
%            auc = [auc,acc];
%            if mod(account,5000) == 0 % every 100 iterations to display auc a time
%                 fprintf('Iter=%d, AUC=%.4f\n', account, auc(account));
%            end
%            account =account+1;
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
%     
%     lenmu = length(mu);
%     fprintf('\nlist the rank:');
%     mu = [mu [1:lenmu]']; % Dimensions of matrices being concatenated are not consistent.  consistent : the lenght or width of A and B must be same 
%     rankMu=sortrows(mu,-1);% 1 means sorting depend on 1st column, -1 means descent sort. 
%     
%     contrast=[rankMu(:,2)';theta];
%     %contrast'
%     fprintf('\n what we get Rank:');
%     fprintf(1, '%02d ',contrast(1,:))
%     fprintf('\n ground-true Rank:');
%     fprintf(1, '%02d ',contrast(2,:))
%     fprintf('');
end
toc
acc = auc;
save (saveFile, 'contrast', 'accuracy')

figure('Name','plot of accuracy-budget','NumberTitle','off')
plot(accuracy);
savefig(saveFig)
saveas(gcf,savePng)
