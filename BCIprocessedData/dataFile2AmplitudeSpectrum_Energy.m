%%%%
% test this function by:
% Amp = data2AmplitudeSpectrum('s01_051017m_epoch.mat',2000,1)
% Amp = data2AmplitudeSpectrum('s01_051017m_epoch.mat',100)
% Amp = Amp = data2AmplitudeSpectrum('s01_051017m_epoch.mat')
%%%%
function [ S ] = dataFile2AmplitudeSpectrum_Energy( datafile, Hz, ech)
%DATA2AMPLITUDESPECTRUM Summary of this function goes here
%   Detailed explanation goes here

    Data = load(datafile)
    %Data=datafile;
    
    nargin
    
    S.RT = Data.RT;
    S.sr = Data.sr;
    if(nargin==3)
        epoches=ech;
        S.RT = Data.RT(1:epoches);
    else
        epoches=length(Data.RT);
    end
    [nch,]=size(Data.data);    
    for epoch=1:epoches
        for ch=1:nch
            [A,f,E] = Single_Side_Amplitude_Spectrum__Energy(Data.data(ch,:,epoch),S.sr,false);
            if(nargin>=2)
                S.Amp(ch,:,epoch)=A(1:(Hz));
            else
                S.Amp(ch,:,epoch)=A;
            end
            S.Eny(ch,epoch)=E;
        end
    end
    if(nargin>=2)
        S.f=f(1:(Hz));
    else
        S.f=f;
    end

end

