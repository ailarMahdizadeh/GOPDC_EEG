clear
clc
close all
% warning off
%% Time-varying simulation for gOPDC analysis represented in ref [1] (Fig. 4)
%%% Written by: Amir Omidvarnia, 2013
%%% Ref [1]: A.  Omidvarnia,  G.  Azemi,  B.  Boashash,  J.  O.  Toole,  P.  Colditz,  and  S.  Vanhatalo, 
%%% ?Measuring  time-varying  information  flow  in  scalp  EEG  signals:  orthogonalized  partial 
%%% directed coherence,?  IEEE  Transactions on Biomedical Engineering, 2013  [Epub ahead of print]
%% Time-varying MVAR model 
load('Temporal.mat')
Fs = 1000; % Sampling frequency (there is no difference between different Fs values for the simulated data. PDCs are the same)
order_max=300;
freq=[4 8;8 13;13 30;30 45]
GOPDC_val=zeros(27,27,33,4);

for index_freq=1:4
    index_freq
for index_subject=1:size(Temporal.Spectral.Theta,3)
    index_subject
    clear('y')
    if index_freq==1
y = Temporal.Spectral.Theta(:,:,index_subject);
    elseif index_freq==2
y = Temporal.Spectral.Alpha(:,:,index_subject);
    elseif index_freq==3
y = Temporal.Spectral.Beta(:,:,index_subject);
    else
y = Temporal.Spectral.Gamma(:,:,index_subject);
    end
L = size(y,1); % Number of samples
CH = size(y,2); % Number of channels



%% DEKF for time-varying MVAR parameter estimation
clear('A')
clear('C')
clear('sbc')
clear('inp_model')
clear('p_opt')
inp_model.data = y;

[w, A, C, sbc, fpe, th] = arfit(y, 1, order_max, 'sbc'); % ---> ARFIT toolbox
[tmp,p_opt] = min(sbc); % Optimum order for the MVAR model
%% Connectivity measures (PDC, gOPDC etc)
clear('Fmax')
clear('Fmin')
clear('f')
clear('GOPDC')
clear('GOPDC_tmp')
clear('imago')
Fmax = freq(index_freq,2);
Fmin=freq(index_freq,1);
Nf=ceil((Fmax-Fmin)/3);
f = linspace(Fmin,Fmax,Nf); % Frequency span
[GOPDC] = PDC_dDTF_imag(A,C,p_opt,Fs,Fmax,Nf,f);

%% Plot
%%%%
GOPDC = abs(GOPDC);

x_max = L;
y_max = Fmax;
for i = 1 : CH
   
    for j = 1 : CH
 
       
        
        
    
        GOPDC_tmp = (GOPDC(i,j,:,:));
        
   
       
       imgo = squeeze(GOPDC_tmp);
       imgo(find(isnan(imgo)==1))=[];
               if(i==j)

            imgo = zeros(size(imgo));
              end

       GOPDC_val(i,j,index_subject,index_freq)=mean(mean(imgo));

        
    end
end

end
end
save('Directional_connectivity.mat','GOPDC_val')
Directional=zeros(33,27*27*4);
for i=1:size(GOPDC_val,3) %subject
    for j=1:size(GOPDC_val,4)  %freq_band
        
        clear('V1')
        clear('V2')
        V1=GOPDC_val(:,:,i,j);
        V2=V1(:);
        V2=V2';
        Directional(i,((j-1)*27*27)+1:j*27*27)=V2;
        
    end
end
save('Directional.mat','Directional')