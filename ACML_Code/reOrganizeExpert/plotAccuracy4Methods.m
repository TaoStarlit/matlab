mydir='./';
%temp1=dir([mydir,'s01*17m_epoch.mat']);
temp1=dir([mydir,'acc_expert*.mat']);%string vector
num_temp1=length(temp1);
figure();
hold on;
for i1=1:num_temp1
    fullPathFile=[mydir,temp1(i1).name];
    load(fullPathFile);
    tmpStr = strrep(fullPathFile,'./acc_expert_23_4_2_1_','')
    plot(accuracy);
end
xlabel('budget');
ylabel('accuracy');
saveas(gcf,'4 Method accuracy-budget.png')