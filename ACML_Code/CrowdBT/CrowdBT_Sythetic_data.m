function data =  CrowdBT_Sythetic_data(n_anno, n_obj, n_data, Alpha, Beta)   
   
   rho = betarnd(Alpha, Beta, 1, n_anno);
   
   all_comb = combnk(1:n_obj, 2);   % all the possible result
   [m,~] = size(all_comb);
   idx = sort(randperm(m,n_data));  % random select the prefernces annotated by worker
   all_comb = all_comb(idx,:);  % select the preference
   data = zeros(n_data*n_anno,3);   % store the generate dataset
 
   for w = 1 : n_anno
       before = (w-1)* n_data+1;
       after = w* n_data;
       data(before:after,1) = w;   % store the index of the worker
       index = rand(n_data,1) < 1-rho(w); 
       temp = all_comb(index,1);
       all_comb(index,1) = all_comb(index,2);
       all_comb(index,2) = temp;
       data(before:after,2:3) = all_comb;
   end
end