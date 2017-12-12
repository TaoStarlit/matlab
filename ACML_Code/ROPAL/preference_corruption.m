function comb_new = preference_corruption(p,comb)
   m = size(comb,1);  % number of task
   k = length(p);     % types of error

   pro = rand(m,1);  % rand value for each tuple
   cum_pro = cumsum(p);  % Cumulative Sum for the probability
   random_pro = repmat(pro,1,k);  % Matrix Expansion for rand value
   real_pro = repmat(cum_pro,m,1); % Matrix Expansion for p

   flag = random_pro > real_pro;
   index = sum(flag,2);

   idx1 = find(index==1); % 1-wrong
   idx2 = find(index==2); % 2-wrong
   idx3 = find(index==3); % 3-wrong(all-wrong)

   if isempty(idx1)==0
       comb = wrong_reverse(idx1,comb,1);
   end
   
   if isempty(idx2)==0
       comb = wrong_reverse(idx2,comb,2);
   end

   if isempty(idx3)==0
       comb = wrong_reverse(idx3,comb,3);
   end
   comb_new = comb;
end

function comb_new = wrong_reverse(idx, comb, t)
   len = round(length(idx)/2);
   idx_a = idx(1:len);
   idx_b = idx(len+1:end);
   if t == 1
       % 50% jik
       temp_b = comb(idx_b,2);
       comb(idx_b,2) = comb(idx_b,1);
       comb(idx_b,1) = temp_b;
       % 50% ikj
       temp_a = comb(idx_a,2);
       comb(idx_a,2) = comb(idx_a,3);
       comb(idx_a,3) = temp_a;
   elseif t == 2
       % 50% reverse kij
       temp_a = comb(idx_a,3);
       comb(idx_a,3) = comb(idx_a,2);
       comb(idx_a,2) = comb(idx_a,1);
       comb(idx_a,1) = temp_a;
       % 50% jki
       temp_b = comb(idx_b,1);
       comb(idx_b,1) = comb(idx_b,2);
       comb(idx_b,2) = comb(idx_b,3);
       comb(idx_b,3) = temp_b;
   else
       % kji
       temp = comb(idx,3);
       comb(idx,3) = comb(idx,1);
       comb(idx,1) = temp;
   end
comb_new = comb;
end