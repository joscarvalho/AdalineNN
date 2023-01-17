clear all; 
clc; 
close all;

load speech.mat
sig = y;

X = randn(length(sig),1); % Noise source

D = sig + 0.7*X; % Speech corrupted with noise

M=length(D); % Signal Length

Delay=10; % Size of the Tapped Delay Line
MSE=0;
b=0; % Bias
alfa=0.01; % Learning Rate
n = 0;
iterations = 4; % Learning Iterations

W=zeros(1,Delay); %Synaptic Weights
TDL=[zeros(1,Delay)]; %Tapped Delay Line
e=zeros(M,1); %Error
y=zeros(M,1); %Noise estimation

while (n < iterations)
    for i = 1 : M-Delay     
        TDL=[X(i) TDL(1:Delay-1)]; %insert X(n) into the first position of the delay line
        
        b=alfa*e(i); %Bias b(n)
        
        %Calculate y(n)
        s = 0;
        for j = 1:Delay
            s = s + TDL(j)*W(j);
        end
        y(i)= s + b;
        
        %Error e(n)
        e(i)=(D(i)-y(i));
        
        %Update synaptic weights
        W = W + (alfa.*e(i)*TDL)';
    end
    
    MSE=(1/M)*sum(e,'all')^2;

    n=n+1;
end

subplot(411); 
plot(sig); title('Signal'); 
subplot(412); 
plot(D); title('Signal plus noise'); 
subplot(413); 
plot(X); title('Reference noise'); 
subplot(414); 
plot(e); title('Signal after noise cancellation '); 

%% May use sound(...) to listen to the samples
% Original sound - sound(sig)
% Reference noise - sound(X)
% Sound + noise - sound(D)
% Reconstructed sound - sound(e)