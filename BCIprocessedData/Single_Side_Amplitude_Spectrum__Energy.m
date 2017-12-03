function [Amp,f,E] = Single_Side_Amplitude_Spectrum__Energy(Sequence, sample_rate, flag_plot)
%SINGLE-SIDE_AMPLITUDE_SPECTRUM Summary of this function goes here
%   Detailed explanation goes here
Fs = sample_rate;             % Sampling frequency ԭ����1000 ���� 250
T = 1/Fs;                     % Sample time
L = length(Sequence);         % Length of signal  ԭ����1000 ����2500
t = (0:L-1)*T;                % Time vector       ������0-10s
% Sum of a 50 Hz sinusoid and a 120 Hz sinusoid
% x = 0.7*sin(2*pi*50*t) + sin(2*pi*120*t); 
% y = x + 0.5*randn(size(t));     % Sinusoids plus noise
y = Sequence;

if(flag_plot==true)
    plot(t(1:L),y(1:L)) %ԭ����Fs*t(1:L)
    title('Signal')
    xlabel('time (seconds)')
end

NFFT = 2^nextpow2(L); % Next power of 2 from length of y
Y = fft(y,NFFT)/L;
f = Fs/2*linspace(0,1,NFFT/2+1);  % 0 - 1/2 Sample Rate
%FFT����
% Plot single-sided amplitude spectrum.
Amp = 2*abs(Y(1:NFFT/2+1));

if(flag_plot==true)
    plot(f,Amp,'r-')
    title('Single-Sided Amplitude Spectrum of y(t)')
    xlabel('Frequency (Hz)')
    ylabel('Amplitude|Y(f)|')
end

E = sum(Sequence.*Sequence)*T;
end

