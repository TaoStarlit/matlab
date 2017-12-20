% function DP = RT2DP(RT)
    dataDir='./result/';
    dataFile='s23_060711_1m_epoch.mat_AF_E.mat';
    load([dataDir,dataFile]);
    RT=S.RT;


    top10=sort(RT);
    top10=top10(1:10);

    normalizedRT=RT/mean(top10);

    d1=-(1+exp(-0.5))/(1-exp(-0.5));
    d2=(2+2*exp(-0.5))/(1-exp(-0.5));
    DP=d1+d2./(1+exp(-0.5*normalizedRT));
    index=find(DP<2);
    
    S.RT=S.RT(index);
    S.Amp=S.Amp(:,:,index);
    save(['less2' dataFile],'S');
%end

