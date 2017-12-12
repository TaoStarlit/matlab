function ground_truth = ground_truth_generation(n_obj, n_average, n_anno, l)
   ground_truth = [];
   N_sample = n_anno*n_average;    
   for n = 1: N_sample
       ground_truth = [ground_truth; randperm(n_obj, l)];
   end

ground_truth = sort(ground_truth,2, 'descend');
end