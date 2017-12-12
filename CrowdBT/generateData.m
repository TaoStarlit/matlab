% W=600;
% L=1000;
% T=1000;
% alpha=[24,4,2,1];

W=150; % W workers
L=250; % L objects
T=250; % each worker has T tasks of annotate their preference on the objects
alpha=[24,4,2,1]; % the hpyerparameter of Dirichlet Distribution

fileName='data_expert_23_4_2_1.mat';
% fileName='data_amateur_5_4_3_2.mat';
% fileName='data_malicious_2_4_5_2.mat';
% fileName='data_spammer_5_5_4_4.mat';
% 
% W=6;
% L=250;
% T=10;
% alpha=[50,50,50,50];

data = zeros(W*T,5); % save the data: each column -- woker ID, 3-ray perference, 
% validation filed(the rand random sample, Dir)

Score(1:L,1)=1:L;
Score(1:L,2)=normrnd(0,1,[L,1]); %generate the ground-true scores: (ID of obj,the score)
% in matlab2016b  L for calculating combination can be 100 200 250 300
AllComb=combnk(1:L,3);%C(n=1000,k=3) in matlab2015 nchoosek or combnk 1st argument must be less than 15
NumComb=length(AllComb);% the number of the Combinations 
fprintf(['NumComb:' NumComb]);

eta=drchrnd(alpha,W);% the eta vector of each work
eta(1:5)%just check
fprintf('eta:');
eta(1:5,1:4)
%����һ��sortȫ�������źã������ӱ���������ֵ
%{
function ground_truth = ground_truth_generation(n_obj, n_average, n_anno, l)
   ground_truth = [];
   N_sample = n_anno*n_average;    
   for n = 1: N_sample
       ground_truth = [ground_truth; randperm(n_obj, l)];
   end

ground_truth = sort(ground_truth,2, 'descend');
end
%}

%{
function r = drchrnd(a,n)%a can be a vector %Function definitions are not permitted in this context.
    % take a sample from a dirichlet distribution
    p = length(a);
    r = gamrnd(repmat(a,n,1),1,n,p);
    r = r ./ repmat(sum(r,2),1,p);
end
%}
%eta=drchrnd([24,3,2,1],W);


% generate the preference task of each workd
for w = 1:W
    fprintf('for worker:%d\r\n',w)
    before = (w-1)*T+1;   %for each annotator, index from 0,  m the number of comb
    after = w*T;
    data(before:after,1) = w; % Wokrer ID
    

    
    iTaskComb = randsample(NumComb,T); %random sample from All Combination, return the index
    for t=1:T
        Task=AllComb(iTaskComb(t),:); % 
        TaskScore=Score(Task,:);  % get a group of ground-true eg.real scores of objects 2 3 8, can be 0.1 -0.2 0.3
        SortedScore=sortrows(TaskScore,-2);% sort descent eg. objs of 8 2 3, scores 0.3 0.1 -0.2
        iSortedSorce=SortedScore(:,1)';
        r=rand;    %rand(n,m)  for the probility of corruptting the preference from the real sort
        if r<eta(w,1) % if the woker is a expert, it is high probability to make the alright preference
            distance=0;
            perferenceOfWorker=iSortedSorce;
        elseif r<sum(eta(w,1:2)) % preference only misses in a little
            distance=1;
            if(rand<0.5)
                perferenceOfWorker=[iSortedSorce(1),iSortedSorce(3),iSortedSorce(2)];
            else
                perferenceOfWorker=[iSortedSorce(2),iSortedSorce(1),iSortedSorce(3)];
            end
        elseif r<sum(eta(w,1:3)) % preference is only right in a little 
            distance=2;
            if(rand<0.5)
                perferenceOfWorker=[iSortedSorce(3),iSortedSorce(1),iSortedSorce(2)];
            else
                perferenceOfWorker=[iSortedSorce(2),iSortedSorce(3),iSortedSorce(1)];
            end
        else % preference is totally wrong,  eg.  a b c --> c b c
            distance=3;
            perferenceOfWorker=fliplr(iSortedSorce);%ֱ�ӵߵ�
        end
        r;
        perferenceOfWorker;
        
        data(before+t-1,2:4) = perferenceOfWorker; %save the preference
        data(before+t-1,5:6) = [r,distance];% save the rand for sample and the distance from ground true
    end 
end

save(['./' fileName],'eta','data','Score'); 
% save('./' fileName,'data'); 
% save('./' fileName,'Score','-append'); 

