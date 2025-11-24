function glrtH1 = glrtqcsig(dataVec,timeVec,psdPosFreq,para_sig)
%% Calculate GLRT for Quadratic chirp signal 
%%
% We will reuse codes that have already been written.
% Path to folder containing signal and noise generation codes.
addpath('C:\yinli\DATASCIENCE_COURSE-main\SIGNALS');
addpath('C:\yinli\DATASCIENCE_COURSE-main\NOISE');


%% Parameters for data realization
% Number of samples and sampling frequency.
nSamples = 2048;
sampFreq = 1024;

%% Generate  data realization
A=2; %SNR
%The signal will be normalized, so generate with an arbitrary amplitude
sig4data = crcbgenqcsig(timeVec,1,para_sig);
% Signal normalized to SNR = A in noise with the specified PSD
[sig4data,~]=normsig4psd(sig4data,sampFreq,psdPosFreq,A);


figure;
plot(timeVec,dataVec);
hold on;
plot(timeVec,sig4data);
xlabel('Time (sec)')
ylabel('Data');
title('Data realization for calculation of LR');

figure;
kNyq = floor(nSamples/2)+1;
dataLen = nSamples/sampFreq;
posFreq = (0:(kNyq-1))*(1/dataLen);
datFFT = abs(fft(dataVec));
sigFFT = abs(fft(sig4data));
plot(posFreq,datFFT(1:kNyq));
hold on;
plot(posFreq,sigFFT(1:kNyq));
xlabel('Frequency (Hz)');
ylabel('Periodogram of data');

figure;
[S,F,T] = spectrogram(dataVec,64,60,[],sampFreq);
imagesc(T,F,abs(S)); axis xy;
xlabel('Time (sec)')
ylabel('Frequency (Hz)');

%% Compute GLRT
%Generate the unit norm signal (i.e., template). As before, the value used for
%'A' does not matter because we are going to normalize the signal anyway.
%Note: the GLRT here is for the unknown amplitude case, that is all other
%signal parameters are known
sigVec = crcbgenqcsig(timeVec,1,para_sig);
%We do not need the normalization factor, just the  template vector with unit norm.
[templateVec,~] = normsig4psd(sigVec,sampFreq,psdPosFreq,1);
% Calculate inner product of the data with the unit norm template
llr = innerprodpsd(dataVec,templateVec,sampFreq,psdPosFreq);
%GLRT is its square
llr = llr^2
disp(llr);

%% Estimate the distribution of GLRT under the null and alternative hypotheses
% Number of data realizations to generate under each hypothesis
nRlz = 500;
%GLRT values stored for each realization
glrtH1 = zeros(1,nRlz); %Alternative hypothesis

%Always a good idea to reset the random number generator when doing large
%simulations for later reproducibility
rng('default');

%Calculate GLRT under null hypothesis: data is pure noise
for lpr = 1:nRlz
    %Generate noise realization
    noiseVec = statgaussnoisegen(nSamples,[posFreq(:),psdPosFreq(:)],100,sampFreq);
    %Compute GLRT
    llr = innerprodpsd(noiseVec,templateVec,sampFreq,psdPosFreq);
    glrtH0(lpr) = llr^2;
end

%Calculate GLRT under alternative hypothesis: data contains the signal
for lpr = 1:nRlz
    %Generate noise realization
    noiseVec = statgaussnoisegen(nSamples,[posFreq(:),psdPosFreq(:)],100,sampFreq);
    %Add signal
    dataVec = noiseVec+sig4data;
    %Compute GLRT
    llr = innerprodpsd(dataVec,templateVec,sampFreq,psdPosFreq);
    glrtH1(lpr) = llr^2;
end
%Plot histograms
figure;
hold on;
histogram(glrtH0,'Normalization',"pdf");
histogram(glrtH1,'Normalization',"pdf")
legend('H0', 'H1');
xlabel('GLRT');
end


%% example
nSamples = 2048;
sampFreq = 1024;
timeVec = (0:(nSamples-1))/sampFreq;
noisePSD = @(f) (f>=100 & f<=300).*(f-100).*(300-f)/10000 + 1;
dataLen = nSamples/sampFreq;
kNyq = floor(nSamples/2)+1;
posFreq = (0:(kNyq-1))*(1/dataLen);
psdPosFreq = noisePSD(posFreq);

%the signal parameter
para_sig=[9.5,2.8,3.2];
%generate the dataVec
sig4data = crcbgenqcsig(timeVec,1,para_sig);
[sig4data,~]=normsig4psd(sig4data,sampFreq,psdPosFreq,A);
noiseVec = statgaussnoisegen(nSamples,[posFreq(:),psdPosFreq(:)],100,sampFreq);
%Data realization = noise realization + signal
dataVec = noiseVec+sig4data;
%genetate the GLRT value
GLRT = glrtqcsig(dataVec,timeVec,psdPosFreq,para_sig)