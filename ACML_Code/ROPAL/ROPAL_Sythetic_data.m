clc
clear
%% initial sythetic parameters
% n_obj:500; n_anno:1000
% n_obj:700; n_anno:1500
% n_obj:1000; n_anno:2000
n_anno = 300;
n_obj = 700; 
n_average = 2000; % fixed no change
alpha = [2,4,5,2];   
% n_average: the average number of preferences annotated by each worker 
rho = drchrnd(alpha,n_anno); % simulated the performance for each worker

%all_comb = ground_truth_generation(n_obj, n_average, n_anno, 3); 
load('all_comb700.mat');

%all the possible result

data = zeros(n_average*n_anno,4);   % store the generate dataset
for w = 1:n_anno
    
    index = randperm(size(all_comb,1),n_average);
    partial_comb = all_comb(index,:);
    
    before = (w-1)*n_average+1;
    after = w*n_average;
    data(before:after,1) = w;
    comb_temp = preference_corruption(rho(w,:),partial_comb);
    data(before:after,2:4) = comb_temp;
end
save data_amature700_300_2_4_5_2.mat data