function [ output_args ] = preProcessDD( DD )
%PREPROCESDD Summary of this function goes here
%   Detailed explanation goes here
    ch1 = DD.data(1,:,1); % the index begin from 1 ������250���������ǣ�1 - 2500��/250 
    rt = DD.RT(1,1);
    sr = DD.sr;
    
    t=1:1:length(ch1);
    t=t/DD.sr;
    %RT = plot(DD.RT)
    plot(t,ch1,'r-') %������������ 
    title(strcat('response time = ',num2str(rt)));
    xlabel('time (seconds)')

    [Amp,Hz] = Single_Side_Amplitude_Spectrum(ch1,sr,true);
    plot(Hz,Amp,'b-')
    %plot(RT','bo')% can't use plot twice in succession
    

end

