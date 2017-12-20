%{
beta 是13到20 所以我就给13到20吧
delta1-4        theta5-7        alpha8-12       beta13-20
17:67           82:116          132:198         213:331       
0.977 4.03      4.94 7.02       7.99 12.02      12.9394 20.1416
s01_051017m_epoch.mat_AF_E.mat
0.46            0.67            0.6             0.57
s12_060710_1m_epoch.mat_AF_E.mat
                0.50

多数通道beta波幅度越小，反应时间越长；
%}

% here later tranverse all the file

dataDir='./result/';
dataDir='./';
dataFile='s12_060710_1m_epoch.mat_AF_E.mat';
%dataFile='s01_051017m_epoch.mat_AF_E.mat';
%dataFile='less2s23_060711_1m_epoch.mat_AF_E.mat';
%dataFile='less2s01_051017m_epoch.mat_AF_E.mat';
load([dataDir,dataFile]);

%{
生成这些data, 所有beta算出来，是woker socre, 大小关系是preference
每个人多少任务，这里是数据生成的那个文件了
只在抽取，不在随机生成; 这里也没有自定义的ground-true,
%}

W=size(S.Amp,1);
L=size(S.RT,2);% size of second dimension
T=500;
data = zeros(W*T,4); % save the data: each column -- woker ID, 3-ray perference, 

AllComb=combnk(1:L,3);%C(n=1000,k=3) in matlab2015 nchoosek or combnk 1st argument must be less than 15
NumComb=length(AllComb);% the number of the Combinations 
fprintf(['NumComb:' int2str(NumComb) '\r\n']);

% generate the preference task of each worker
for w = 1:W
    fprintf('for worker:%d\r\n',w)
    before = (w-1)*T+1;   %for each annotator, index from 0,  m the number of comb
    after = w*T;
    data(before:after,1) = w; % Wokrer ID

    iTaskComb = randsample(NumComb,T); %random sample from All Combination, return the index
    for t=1:T
        Task=AllComb(iTaskComb(t),:); %  get a Task
        score_index=zeros(3,2);
        for e=1:3
            %betaPower=sum(S.Amp(w,82:116,Task(e))); %31*2029*241  channel * A-f * numberOfTrail
            betaPower=S.Eny(w,Task(e));
            %betaPower=S.RT(1,Task(e));%测出98%说明代码逻辑没有问题(如果alpha出事6，6，2，2就剩下70）
            score_index(e,:)=[betaPower,Task(e)];
        end
        score_index=sortrows(score_index,-1);
        perferenceOfWorker=score_index(:,2)';
        data(before+t-1,2:4) = perferenceOfWorker; %save the preference
    end
end


%发现真正的ROPAL还没调通，回去才看看
%beta的分数其实都是差不多从30到50应该是正态分布，能否全部给它当作了是N(0,1)映射过去

% n_anno=size(S.Amp,1); %31*2029*241  channel * A-f * numberOfTrail
% n_obj=size(S.RT);
n_anno = max(data(:,1));  % number of worker
n_obj  = max(max(data(:,2:end)));  % number of object
n_data = size(data,1);  % size of the data
budget=10000;
theta = RT2DP(S.RT); % ground-true
%doc_diff = Score(:,2); %1:1:n_obj; ground-true


%% set up initial parametmers 
% parameters for all objects
mu  =  zeros(n_obj,1);   % mean = 0
sigma  =  ones(n_obj,1);  % sigma = 1

% parameters for all workers
% alpha0  =  6;
% beta0   =  4;
% alpha   =  alpha0.*ones(n_anno,1);
% beta    =  beta0.*ones(n_anno,1);

%alpha_ini=[23,3,1,0.5];
alpha_ini=[20,6,1,0.5];
alpha=repmat(alpha_ini,[n_anno,1]);



% taylor = 1 because we empoly taylor expansion
online_para=struct('c', 0.1, 'kappa', 1e-4, 'taylor', 1);
accuracy = [];
count=0;
for num = 1:1 % independent experiment
    for N = 1 : 1  % times run through the data  N= 5
       %% online Bayesian optimization for tuple (i,j,k) and worker K
        idx = randi(n_data,[1,budget]);
        for r = 1 : budget % n_data
            i = data(idx(r), 2);
            j = data(idx(r), 3);
            k = data(idx(r), 4);
            K = data(idx(r), 1);
%            [mu(i), mu(j), sigma(i), sigma(j), alpha(K), beta(K)]...
%                 = online_update_CrowdBT(mu(i), mu(j), sigma(i), sigma(j), alpha(K), beta(K), online_para);
%            [mu(i), mu(k), sigma(i), sigma(k), alpha(K), beta(K)]...
%                 = online_update_CrowdBT(mu(i), mu(k), sigma(i), sigma(k), alpha(K), beta(K), online_para);
%            [mu(j), mu(k), sigma(j), sigma(j), alpha(K), beta(K)]...
%                 = online_update_CrowdBT(mu(j), mu(k), sigma(j), sigma(k), alpha(K), beta(K), online_para);
            [mu(i), mu(j), mu(k), sigma(i), sigma(j), sigma(k), alpha(K,1), alpha(K,2), alpha(K,3), alpha(K,4)]...
                = online_update_ROPAL(mu(i), mu(j), mu(k), sigma(i), sigma(j), sigma(k), alpha(K,1), alpha(K,2), alpha(K,3), alpha(K,4), online_para);
            
            
            dist = 0;
            for xx = 1:n_obj %???????е????xx yy?????????????????ζ????
                for yy = xx+1:n_obj
                    if (mu(xx) - mu(yy))*(theta(xx) - theta(yy)) > 0 %?????mu?????????????????????????1
                        dist = dist + 1;
                    end
                end
            end
            acc = 2 * dist / (n_obj * (n_obj-1));
            count=count+1;
            accuracy(count)=acc;
            if(mod(count,50)==0)
                fprintf('iter:%06d, accuracy:%0.3f\n',count,accuracy(count));  
            end          
        end
    end
end

