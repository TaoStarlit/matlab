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

%%%%%%%%%%%%%%%%%%%%%%%%%%
plan
%%%%%%%%%%%%%%%%%%%%%%%%%%
how to transform the time sequence in all channel to the ordered channel, 
the methods can be power frequency conherence and linear mapping.

insight the distribution of the RT , hist