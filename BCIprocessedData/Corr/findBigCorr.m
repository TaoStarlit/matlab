%% validate how to get the top 3 indices and value
a=[0,-7,3,-3,NaN,-5,6];

[top3indices, top3value, NaNCh]=GetAbsTop3(a)
% numCh=length(a);
% 
% sortTable=[a;1:numCh];
% sorted=sortrows(abs(sortTable'),-1);
% 
% top3indices=sorted(1:3,2);
% top3value=a(top3indices);



mydir='./';
fileArray=dir([mydir,'s*_corr.mat']);
num_files=length(fileArray)

IndicesValue=zeros(num_files,30);

source=strrep(fileArray(1).name,'_corr.mat','');% here is the char vector
sl=length(source);
DataSource=char()
for i=1:num_files
    fullPathFile=[mydir,fileArray(i).name];
    source=strrep(fileArray(i).name,'_corr.mat','');
    source=source(1:sl);
    %source=string(source); % source=string(source);
    load(fullPathFile);

 
    [deltaIndicesMax,deltaValue,nand]=GetAbsTop3(correDelta);
    [thetaIndicesMax,thetaValue,nant]=GetAbsTop3(correTheta);
    [alphaIndicesMax,alphaValue,nana]=GetAbsTop3(correAlpha);
    [beta_IndicesMax,beta_Value,nanb]=GetAbsTop3(correBeta);
    [energyIndicesMax,energyValue,nann]=GetAbsTop3(correEner);
    
    newRow=[deltaIndicesMax,deltaValue,thetaIndicesMax,thetaValue,alphaIndicesMax,alphaValue,beta_IndicesMax,beta_Value,energyIndicesMax,energyValue];
    if length(newRow)<30
        fprintf('data wrong in file:',source);
        Errorcode=length(newRow)
    end
    X=length(newRow);
    IndicesValue(i,:)=newRow;
    DataSource=[DataSource;source];
    NumOfCh(i,1)=length(correEner);

%     savedir = './corr/';    
%     saveName = strrep(fileArray(i).name,'.mat_AF_E.mat','');
%     savePath = [savedir,saveName,'_corr.mat']
%     save(savePath,'correEner','correDelta','correTheta','correAlpha','correBeta'); 
end

save('./top3chs_PowerOfBand.mat','IndicesValue','DataSource','NumOfCh');
