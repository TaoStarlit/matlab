mydir='./Processed_data_10s/';
%temp1=dir([mydir,'s01*17m_epoch.mat']);
temp1=dir([mydir,'s*_epoch.mat']);
num_temp1=length(temp1);
 for i1=1:num_temp1
    fullPathFile=[mydir,temp1(i1).name];

    S=dataFile2AmplitudeSpectrum_Energy(fullPathFile);% 出错,因为56以后，有些是31个通道的
    
    saldir = './result/'
    savePath = [saldir temp1(i1).name '_AF_E' '.mat'];
    save(savePath,'S'); 
 end