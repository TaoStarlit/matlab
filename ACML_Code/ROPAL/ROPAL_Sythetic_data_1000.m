%% fixed no change
n_anno = 600; 
n_obj = 1000; 
n_average = 1000; 

%%parameters
alpha = [23,4,2,1]; % n_average: the average number of preferences annotated by each worker 
rho = drchrnd(alpha,n_anno); % simulated the performance for each worker
save rho_expert.mat rho
%% generate the training corrupted data
data = zeros(n_average*n_anno,4); % store the generate dataset
% index = randperm(size(all_comb1000,1),n_average);
% partial_comb = all_comb1000(index,:);
% save clean_data.mat partial_comb
load('clean_data.mat')
for w = 1:n_anno
    before = (w-1)*n_average+1;
    after = w*n_average;
    data(before:after,1) = w;
    comb_temp = preference_corruption(rho(w,:),partial_comb);
    data(before:after,2:4) = comb_temp;
end
save data_expert_23_4_2_1.mat data

alpha = round(rho*15 + rand(size(rho))+0.5);
alpha = alpha./repmat(sum(alpha,2),1,size(alpha,2));%estimated expected value

save alpha_expert_ROPAL.mat alpha

beta = round(15*[rho(:,1)+2/3*rho(:,2)+1/3*rho(:,3),2/3*rho(:,2)+1/3*rho(:,3)+rho(:,4)]+0.5);
beta  = beta./repmat(sum(beta,2),1,size(beta,2));%estimated expected value
save beta_expert_CrowdBT.mat beta

