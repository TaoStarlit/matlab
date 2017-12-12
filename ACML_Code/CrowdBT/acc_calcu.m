function acc = acc_calcu(doc, mu, N_obj, CNK)
%% calculate the accuracy based on ground truth

corr  = 0;
count = 0;

for i = 1 : N_obj-1
    for j = i+1 : N_obj
        if mu( i ) < mu( j )
            corr = corr +1;
        end         
    end
end

acc = corr/CNK;