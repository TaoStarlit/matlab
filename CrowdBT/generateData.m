W=600;
L=1000;
T=1000;
alpha=[24,3,2,1];

fileName='data_expert_23_4_2_1.mat';
% fileName='data_amateur_5_4_3_2.mat';
% fileName='data_malicious_2_4_5_2.mat';
% fileName='data_spammer_5_5_4_4.mat';

% W=6;
% L=10;
% T=10;
% alpha=[50,50,50,50];

data = zeros(W*T,5); % 600个工人，每人1000个任务


Score(1:L,1)=1:L;
Score(1:L,2)=normrnd(0,1,[L,1]);

AllComb=nchoosek(1:L,3);
NumComb=length(AllComb);

%可以一个sort全部给你排好，这样子保留了索引值
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
eta=drchrnd(alpha,W);
eta(1:5)%就只取了每一行的第一个元素
eta(1:5,1:4)

for w = 1:W
    before = (w-1)*T+1;   %for each annotator, index from 0,  m the number of comb
    after = w*T;
    data(before:after,1) = w; % 第一列是worker编号，二三列是这个组合
    
    % 1000个里面选三组 ，先把所有组合列好，C(3 1000)也是不少啊，然后抽下标； 或者，简单产生三个随机数1-1000均值分布
    %三个数选好了，排序也有了，怎么用eta让其变乱呢？ --- 参照 crowdBT
    iTaskComb = randsample(NumComb,T); %Task个  组合的索引
    for t=1:T
        Task=AllComb(iTaskComb(t),:); % 每一次例如 2 3 8 然后在S把他们取出来
        TaskScore=Score(Task,:)  %Score=[[1:8];[11:18]]' 命令行先用这个试验,  果真取出来了
        SortedScore=sortrows(TaskScore,-2)%默认是升序的，貌似不给降序 ; 回答： 可以 第二列 2 改成 -2
        iSortedSorce=SortedScore(:,1)';
        r=rand;    %rand(n,m)0，1均匀分布的矩阵，单独rand就是0，1
        if r<eta(w,1)
            distance=0;
            perferenceOfWorker=iSortedSorce;
        elseif r<sum(eta(w,1:2))
            distance=1;
            if(rand<0.5)
                perferenceOfWorker=[iSortedSorce(1),iSortedSorce(3),iSortedSorce(2)];
            else
                perferenceOfWorker=[iSortedSorce(2),iSortedSorce(1),iSortedSorce(3)];
            end
        elseif r<sum(eta(w,1:3))
            distance=2;
            if(rand<0.5)
                perferenceOfWorker=[iSortedSorce(3),iSortedSorce(1),iSortedSorce(2)];
            else
                perferenceOfWorker=[iSortedSorce(2),iSortedSorce(3),iSortedSorce(1)];
            end
        else
            distance=3;
            perferenceOfWorker=fliplr(iSortedSorce);%直接颠倒
        end
        r
        perferenceOfWorker
        
        data(before+t-1,2:4) = perferenceOfWorker;
        data(before+t-1,5:6) = [r,distance];%顺便把随机数也记录进去
    end 
end

save(['./' fileName],'data','Score'); 
% save('./' fileName,'data'); 
% save('./' fileName,'Score','-append'); 

%全概率公式，决定了要不要颠倒
%{
        split = rho(k) * theta(i) / (theta(i) + theta(j)) + (1 - rho(k)) * theta(j) / (theta(i) + theta(j));%奇怪是，实际分数，可以这样子拿出来，不是靠学的吗？
        if rand > split % i,j颠倒一下，  rand找不到定义，好奇怪！  这里才是真正的输入数据，i是否比j大，要经过 预设的 评论者素质和目标的分数
            i = data(r,3);
            j = data(r,2);
        end
%}