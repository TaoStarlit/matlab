%构造出信号（如已有信号，此步可省略）
Fs = 1000;                    % Sampling frequency
T = 1/Fs;                     % Sample time
L = 1000;                     % Length of signal
t = (0:L-1)*T;                % Time vector   乘以小于1的数，如采样周期，使得信号在x轴压缩
% Sum of a 50 Hz sinusoid and a 120 Hz sinusoid
eRMS=0.707;
x = sin(2*pi*10*t);
y = (t-t)+eRMS;
%x = 0.7*sin(2*pi*50*t) + sin(2*pi*120*t); 
%y = x + 0.5*randn(size(t));     % Sinusoids plus noise
%plot(Fs*t(1:50),y(1:50))
figure;
plot(t(1:L),x(1:L),'b-') %原本是Fs*t(1:L)
title('Sine and Direct Signal')
xlabel('time (seconds)')
hold on;
plot(t(1:L),y(1:L),'r-')

figure;
title('Power')
Px=x.*x;
Py=y.*y;
plot(t(1:L),Px(1:L),'b-') %原本是Fs*t(1:L)
title('Sine and Direct Power')
xlabel('time (seconds)')
hold on;
plot(t(1:L),Py(1:L),'r-')

Wx=sum(Px)*T%乘以采样周期，与用公式积分计算的总能量，结果完全一致
Wy=sum(Py)*T


ix = @(t) sin(2*pi*10*t);
iy = @(t) (t-t)+eRMS;
Ix = integral(ix,0,1) 
Iy = integral(iy,0,1)
ipx = @(t) (sin(2*pi*10*t)).*(sin(2*pi*10*t));
ipy = @(t) ((t-t)+eRMS)*eRMS;
Ipx = integral(ipx,0,1) 
Ipy = integral(ipy,0,1)
%正弦波正确，能量计算结果，约等于  峰值均方根RMS 1/根号二  0.707的直流信号


%{
NFFT = 2^nextpow2(L); % Next power of 2 from length of y
Y = fft(y,NFFT)/L;
f = Fs/2*linspace(0,1,NFFT/2+1);
%FFT分析
% Plot single-sided amplitude spectrum.
plot(f,2*abs(Y(1:NFFT/2+1))) 
title('Single-Sided Amplitude Spectrum of y(t)')
xlabel('Frequency (Hz)')
ylabel('|Y(f)|')
%}
