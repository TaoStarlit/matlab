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
power���� �������㣺 ���������źŷ��棬�����ң���ֱ����һ�������������Լ���ͼ
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
����������ͨ���ǹ�һ�����������Ǽ��� ������1�����ʾ���uƽ�������������� uƽ����ʱ����֣� ƽ�����ʣ��������������ܵ�ʱ�䣻
1�����ڲ����õ�����ɢ�źţ���������������أ�
2��ÿһ���ڲ�ƽ��һ��,  matlab  .* ���������� element-wise multiplication��  ������*���Ǿ���˷��������ӱ����
3��������ɢ������ȫ���������������ˡ�������  ��ע��һ�£������ʣ� �����Բ������ڼ���


%%%%%%%%%%%%%%%%%%%%%%%%%%%%
�����ļ�mat�ļ�������һ��
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