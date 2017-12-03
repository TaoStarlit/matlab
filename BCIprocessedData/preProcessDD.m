function [ output_args ] = preProcessDD( DD, channel, epoch )
%PREPROCESDD Summary of this function goes here
%   Detailed explanation goes here
    if(nargin==3)
        ep=epoch;
        ch=channel;
    else
        ep=1;
        ch=1;
    end
        
    ch1 = DD.data(ch,:,ep); % the index begin from 1 采样率250所以这里是（1 - 2500）/250 
    rt = DD.RT(ch,ep);
    sr = DD.sr;
    
    t=1:1:length(ch1);
    t=t/DD.sr;
    %RT = plot(DD.RT)
    plot(t,ch1,'r-') %看这个求出功率 
    title(strcat('response time = ',num2str(rt)));
    xlabel('time (seconds)')

    [Amp,Hz] = Single_Side_Amplitude_Spectrum(ch1,sr,true);
    plot(Hz,Amp,'b-')
    title(strcat('response time = ',num2str(rt)));
    xlabel('Frequence Hz')
    %plot(RT','bo')% can't use plot twice in succession
    

end

