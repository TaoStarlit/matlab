%2.5秒 0.25秒 采样1000

%构造出信号（如已有信号，此步可省略）
Fs = 250;                    % Sampling frequency
T = 1/Fs;                     % Sample time
L = 2500;                     % Length of signal
t = (0:L-1)*T;                % Time vector
% Sum of a 50 Hz sinusoid and a 120 Hz sinusoid
% x = 0.7*sin(2*pi*50*t) + sin(2*pi*120*t); 
x = 0.7*sin(2*pi*50*t); % 这里就50HZ??
y = x + 0.5*randn(size(t));     % Sinusoids plus noise

Single_Side_Amplitude_Spectrum(x(1:250),Fs,true); % 
% 结果正确，从两个图对比出来， 50Hz正弦波， 单边功率谱尖峰在50Hz处           
