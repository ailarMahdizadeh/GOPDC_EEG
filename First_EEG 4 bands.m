clc;
close all;
 clear;

  load('EEG_test_new.mat')
%% Making 4 gropus of EEG signals

Num.HC=n.HC;
Num.PD=n.PD;
Num.Channel=size(y,2);
Num.Tot=n.Tot;
Num.Time=size(y,1);






fs=1000;
ts=1/fs;
Fs=fs;
Len=size(y,1);
f=fs.*(0:Len-1)/Len;
Band.Theta=[4 8;fs-8 fs-4];
Band.Alpha=[8 13;fs-13 fs-8];
Band.Beta=[13 30;fs-30 fs-13];
Band.Gamma=[30 45;fs-45 fs-30];

freq_Theta1=find(f>=Band.Theta(1,1) & f<=Band.Theta(1,2));
freq_Theta2=find(f>=Band.Theta(2,1) & f<=Band.Theta(2,2));
freq.Theta=[freq_Theta1 freq_Theta2];

freq_Alpha1=find(f>=Band.Alpha(1,1) & f<=Band.Alpha(1,2));
freq_Alpha2=find(f>=Band.Alpha(2,1) & f<=Band.Alpha(2,2));
freq.Alpha=[freq_Alpha1 freq_Alpha2];

freq_Beta1=find(f>=Band.Beta(1,1) & f<=Band.Beta(1,2));
freq_Beta2=find(f>=Band.Beta(2,1) & f<=Band.Beta(2,2));
freq.Beta=[freq_Beta1 freq_Beta2];

freq_Gamma1=find(f>=Band.Gamma(1,1) & f<=Band.Gamma(1,2));
freq_Gamma2=find(f>=Band.Gamma(2,1) & f<=Band.Gamma(2,2));
freq.Gamma=[freq_Gamma1 freq_Gamma2];

FFT_y=0.*y;
EEG.Spectral.Alpha=FFT_y;
EEG.Spectral.Theta=FFT_y;
EEG.Spectral.Beta=FFT_y;
EEG.Spectral.Gamma=FFT_y;


%% Bands


for i=1:Num.Tot
 i
    for j=1:Num.Channel
        
        FFT_y(:,j,i)=(fft(y(:,j,i)));
EEG.Spectral.Theta(freq.Theta,j,i)=FFT_y(freq.Theta,j,i);
EEG.Spectral.Alpha(freq.Alpha,j,i)=FFT_y(freq.Alpha,j,i);
EEG.Spectral.Beta(freq.Beta,j,i)=FFT_y(freq.Beta,j,i);
EEG.Spectral.Gamma(freq.Gamma,j,i)=FFT_y(freq.Gamma,j,i);


Temporal.Spectral.Theta(:,j,i)=ifft(EEG.Spectral.Theta(:,j,i));
Temporal.Spectral.Alpha(:,j,i)=ifft(EEG.Spectral.Alpha(:,j,i));
Temporal.Spectral.Beta(:,j,i)=ifft(EEG.Spectral.Beta(:,j,i));
Temporal.Spectral.Gamma(:,j,i)=ifft(EEG.Spectral.Gamma(:,j,i));

    end
end








 save('Temporal.mat','Temporal')

