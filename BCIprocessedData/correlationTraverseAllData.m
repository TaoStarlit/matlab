% dataDir='./result/';
% %dataDir='./';
% dataFile='s12_060710_1m_epoch.mat_AF_E.mat';
% %dataFile='s01_051017m_epoch.mat_AF_E.mat';
% %dataFile='less2s23_060711_1m_epoch.mat_AF_E.mat';
% %dataFile='less2s01_051017m_epoch.mat_AF_E.mat';
% load([dataDir,dataFile]);

mydir='./result/';
%temp1=dir([mydir,'s01*17m_epoch.mat']);
fileArray=dir([mydir,'s*_AF_E.mat']);
num_files=length(fileArray);
 for i=1:num_files
    fullPathFile=[mydir,fileArray(i).name];
    
    
    savedir = './corr/';    
    saveName = strrep(fileArray(i).name,'.mat_AF_E.mat','');
    savePath = [savedir,saveName,'_corr.mat']
    
    
    load(fullPathFile);

    %% all energy;  beta power; alpha power
% delta1-4        theta5-7        alpha8-12       beta13-20
% 17:67           82:116          132:198         213:331       
% 0.977 4.03      4.94 7.02       7.99 12.02      12.9394 20.1416

    [W,x,O]=size(S.Amp);
    deltaPower=[];
    thetaPower=[];
    alphaPower=[];
    betaPower=[];
    for w=1:W
        for o=1:O
            deltaPower(o,w)=sum(S.Amp(w,17:67,o));
            thetaPower(o,w)=sum(S.Amp(w,82:116,o));
            alphaPower(o,w)=sum(S.Amp(w,132:198,o));
            betaPower(o,w)=sum(S.Amp(w,213:331,o));
        end
    end
    correDelta=corr(S.RT', deltaPower, 'type','Kendall')
    correTheta=corr(S.RT', thetaPower, 'type','Kendall')
    correAlpha=corr(S.RT', alphaPower, 'type','Kendall')
    correBeta=corr(S.RT', betaPower, 'type','Kendall')
    correEner=corr(S.RT',S.Eny','type','Kendall');
    
    

    save(savePath,'correEner','correDelta','correTheta','correAlpha','correBeta'); 
 end





%% Kendall tau distance    about rank correlation
% a=[1,2,3,4];
% b=[1,2,3,4; 10,20,300,301; 1,2,4,3; 2,1,3,4; 3,2,1,4; 1,4,3,2; 4,1,2,3; 2,3,4,1; 4,3,2,1]
% corre=corr(a',b','type','Kendall')
% validation result 1.0000    1.0000    0.6667    0.6667         0         0         0         0   -1.0000
% this distance function is what we need


