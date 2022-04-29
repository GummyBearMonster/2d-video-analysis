Fs = 250;            % Sampling frequency                    
T = 1/Fs;             % Sampling period       
L = 30000;             % Length of signal
t = (0:L-1)*T;        % Time vector
Y=fft(regular_co);
P2=abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = Fs*(0:(L/2))/L;
plot(f,P1) 
