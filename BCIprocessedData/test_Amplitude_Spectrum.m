%2.5�� 0.25�� ����1000

%������źţ��������źţ��˲���ʡ�ԣ�
Fs = 250;                    % Sampling frequency
T = 1/Fs;                     % Sample time
L = 2500;                     % Length of signal
t = (0:L-1)*T;                % Time vector
% Sum of a 50 Hz sinusoid and a 120 Hz sinusoid
% x = 0.7*sin(2*pi*50*t) + sin(2*pi*120*t); 
x = 0.7*sin(2*pi*50*t); % �����50HZ??
y = x + 0.5*randn(size(t));     % Sinusoids plus noise

Single_Side_Amplitude_Spectrum(x(1:250),Fs,true); % 
% �����ȷ��������ͼ�Աȳ����� 50Hz���Ҳ��� ���߹����׼����50Hz��           
