%{
beta ��13��20 �����Ҿ͸�13��20��
213     331       
12.9394 20.1416

����ͨ��beta������ԽС����Ӧʱ��Խ����
%}

% here later tranverse all the file

dataDir='./result/';
%dataFile='s01_051017m_epoch.mat_AF_E.mat';
dataFile='s09_060313n_epoch.mat_AF_E.mat';
load([dataDir,dataFile]);

%{
������Щdata, ����beta���������woker socre, ��С��ϵ��preference
ÿ���˶��������������������ɵ��Ǹ��ļ���
ֻ�ڳ�ȡ�������������; ����Ҳû���Զ����ground-true,
%}

W=size(S.Amp,1);
L=size(S.RT,2);% size of second dimension
T=250;

BetaRT=zeros(W+1,L);
for l=1:L
    for w=1:W
        beta=sum(S.Amp(w,213:331,l));
        BetaRT(w,l)=beta;
    end
end
BetaRT(w+1,:)=RT2DP(S.RT);



    
data = zeros(W*T,7); % save the data: each column -- woker ID, 3-ray perference, 

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
            betaPower=sum(S.Amp(w,213:331,Task(e))); %31*2029*241  channel * A-f * numberOfTrail
            score_index(e,:)=[betaPower,Task(e)];
        end
        score_index=sortrows(score_index,-1);
        perferenceOfWorker=score_index(:,2)';
        data(before+t-1,2:4) = perferenceOfWorker; %save the preference
        data(before+t-1,5:7) = S.RT(perferenceOfWorker);
    end
end


