Baseline Data= 5 Minute Resting State Data

chanlocs= Channel Location Information

data= Channel X Time (10s) X Epochs

RT= Reaction Time for Each Epoch

sr= Sampling Rate



%%%%%%%%%%%%%%%%%%%%%%%%%%%
analysis
%%%%%%%%%%%%%%%%%%%%%%%%%%%
s02_050921m_epoch
s01_051017m_epoch
    double click --> load('s01_051017m_epoch')
    33*2500*150
    33*2500*35   ---- 33 channels   2500 time points        35 train data    
    Cannot display summaries of variables with more than 524888 element

DD = 

              sr: 250
    BaselineData: [33x75000 single]
              RT: [1x35 double]
            data: [33x2500x35 single]

%%%%%%%%%%%%%%%%%%%%%%%%%%
plan
%%%%%%%%%%%%%%%%%%%%%%%%%%
how to transform the time sequence in all channel to the ordered channel, 
the methods can be : power / frequency /conherence / linear mapping.

insight the distribution of the RT , hist

----
input a file -- the struct
output the AmplitudeSpectrum And RT
Amplitude : 33*140*epoch   RT 1*epoch    
%%% finished the function
function [ S ] = data2AmplitudeSpectrum( datafile, Hz, ech)
%%% input :
File,  
Hz: how many amplitude points do you want get (the amplitudes of high frequency may be near 0), 
ech:how many epoches you want to get(Cannot display summaries of variables with more than 524288 elements.)

--- generate the frenquence data files



%%%%%%%%%%%%%%%%%%%%%%%%%%%%
power功率 功，计算： 先用其他信号仿真，如正弦，如直流，一样给出采样率以及画图
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
计算能量，通常是归一化处理，所以是假设 电阻是1，则功率就是u平方，而能量就是 u平方对时间积分； 平均功率，就是能量除以总的时间；
1、对于采样得到的离散信号，积分是如何做的呢？
2、每一点内部平方一下,  matlab  .* 就是逐个相乘 element-wise multiplication，  正常的*就是矩阵乘法，最后相加变标量
3、对于离散采样，全部加起来个就完了。。。。  再注意一下，采样率， 最后乘以采样周期即可


%%%%%%%%%%%%%%%%%%%%%%%%%%%%
所有文件mat文件都处理一下
%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%
filename rule
%%%%%%%%%%%%%%%%%%%%%%%%%%%
1\ reference sample
    fftsample.m   powersample.m
2\ my fundamental function
    Single_Side_Amplitude_Spectrum.m
    Single_Side_Amplitude_Spectrum_Energy.m
3\ test my fundamental function
    test_Amplitude_Spectrum.m
4\ preparation for all operation 
4.1precess data:
    proPrecessDD.m
    data2AmplitudeSpectrum.m
4.2 tranverse files
    TranverseAllFiles.m
5\ Final operation
    data2AmplitudeSpectrum.m