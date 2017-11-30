%%%%
% test this function by:
% Amp = data2AmplitudeSpectrum('s01_051017m_epoch.mat',2000,1)
% Amp = data2AmplitudeSpectrum('s01_051017m_epoch.mat',100)
% Amp = Amp = data2AmplitudeSpectrum('s01_051017m_epoch.mat')
%%%%
function [ S ] = data2AmplitudeSpectrum( datafile, Hz, ech)
%DATA2AMPLITUDESPECTRUM Summary of this function goes here
%   Detailed explanation goes here

    Data = load(datafile)
    %Data=datafile;
    
    nargin
    
    S.RT = Data.RT;
    S.sr = Data.sr;
    if(nargin==3)
        epoches=ech;
    else
        epoches=length(Data.RT);
    end
        
    for epoch=1:epoches
        for ch=1:33
            [A,f] = Single_Side_Amplitude_Spectrum(Data.data(ch,:,epoch),S.sr,false);
            if(nargin>=2)
                S.Amp(ch,:,epoch)=A(1:(Hz));
            else
                S.Amp(ch,:,epoch)=A;
            end
        end
    end
    if(nargin>=2)
        S.f=f(1:(Hz));
    else
        S.f=f;
    end

end

