% W=600;
% L=1000;
% T=1000;
% alpha=[24,3,2,1];

W=150;
L=250;
T=250;
alpha=[24,3,2,1];

fileName='data_expert_23_4_2_1.mat';
% fileName='data_amateur_5_4_3_2.mat';
% fileName='data_malicious_2_4_5_2.mat';
% fileName='data_spammer_5_5_4_4.mat';
% 
% W=6;
% L=250;
% T=10;
% alpha=[50,50,50,50];

data = zeros(W*T,5); % 600�����ˣ�ÿ��1000������


Score(1:L,1)=1:L;
Score(1:L,2)=normrnd(0,1,[L,1]);
% in matlab2016b  L can be 100 200 250 300, larger than 15
AllComb=combnk(1:L,3);%nchoosek or combnk :the n must less than 15
NumComb=length(AllComb);
fprintf(['NumComb:' NumComb]);

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
eta=drchrnd(alpha,W);
eta(1:5)%��ֻȡ��ÿһ�еĵ�һ��Ԫ��
fprintf('eta:');
eta(1:5,1:4)


for w = 1:W
    fprintf('for worker:%d\r\n',w)
    before = (w-1)*T+1;   %for each annotator, index from 0,  m the number of comb
    after = w*T;
    data(before:after,1) = w; % ��һ����worker��ţ���������������
    
    % 1000������ѡ���� ���Ȱ���������кã�C(3 1000)Ҳ�ǲ��ٰ���Ȼ����±ꣻ ���ߣ��򵥲�����������1-1000��ֵ�ֲ�
    %�����ѡ���ˣ�����Ҳ���ˣ���ô��eta��������أ� --- ���� crowdBT
    iTaskComb = randsample(NumComb,T); %Task��  ��ϵ�����
    for t=1:T
        Task=AllComb(iTaskComb(t),:); % ÿһ������ 2 3 8 Ȼ����S������ȡ����
        TaskScore=Score(Task,:);  %Score=[[1:8];[11:18]]' �����������������,  ����ȡ������
        SortedScore=sortrows(TaskScore,-2);%Ĭ��������ģ�ò�Ʋ����� ; �ش� ���� �ڶ��� 2 �ĳ� -2
        iSortedSorce=SortedScore(:,1)';
        r=rand;    %rand(n,m)0��1���ȷֲ��ľ��󣬵���rand����0��1
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
            perferenceOfWorker=fliplr(iSortedSorce);%ֱ�ӵߵ�
        end
        r;
        perferenceOfWorker;
        
        data(before+t-1,2:4) = perferenceOfWorker;
        data(before+t-1,5:6) = [r,distance];%˳��������Ҳ��¼��ȥ
    end 
end

save(['./' fileName],'data','Score'); 
% save('./' fileName,'data'); 
% save('./' fileName,'Score','-append'); 

%ȫ���ʹ�ʽ��������Ҫ��Ҫ�ߵ�
%{
        split = rho(k) * theta(i) / (theta(i) + theta(j)) + (1 - rho(k)) * theta(j) / (theta(i) + theta(j));%����ǣ�ʵ�ʷ�������������ó��������ǿ�ѧ����
        if rand > split % i,j�ߵ�һ�£�  rand�Ҳ������壬����֣�  ������������������ݣ�i�Ƿ��j��Ҫ���� Ԥ��� ���������ʺ�Ŀ��ķ���
            i = data(r,3);
            j = data(r,2);
        end
%}