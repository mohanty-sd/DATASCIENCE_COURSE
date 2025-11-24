%%
% noisePSD = @(f) (f>=50 & f<=100).*(f-50).*(100-f)/625 + 1;
nSamples = 2048;
%sampFreq = 512;


%%
[pxx, f] = pwelch(trainData, [], [], [], sampFreq);
timeVec = (0:(nSamples-1))/sampFreq;

%%
% Generate the PSD vector to be used in the normalization. Should be
% generated for all positive DFT frequencies. 
dataLen = nSamples/sampFreq;
kNyq = floor(nSamples/2)+1;
posFreq = (0:(kNyq-1))*(1/dataLen);
original_indices = 1:length(pxx);
new_indices = linspace(1, length(pxx), 1025);

% 使用线性插值方法生成新的稀疏向量
psdPosFreq = interp1(original_indices, pxx, new_indices, 'linear');


figure;
plot(posFreq,psdPosFreq);
axis([0,posFreq(end),0,max(psdPosFreq)]);
xlabel('Frequency (Hz)');
ylabel('PSD ((data unit)^2/Hz)');


%%
rng('default')
rmin = [10,10,5];
rmax = [100,50,50];
%%
% Call PSO.
steps = 2000;
inParams = struct('rmin', rmin,...
                     'rmax', rmax, ...
                    'dataX', timeVec,...
                    'dataY', dataVec,...
                    'psdPosFreq',psdPosFreq,...
                    'sampFreq',sampFreq, ...
                    'dataXSq',timeVec.^2, ...
                    'dataXCb',timeVec.^3);
psoParams = struct('maxSteps',steps);
nRuns = 8;

%%
% fitFuncHandle = @(x) Lab5_crcbpsotestfunc(x,inParams);
%%
% Call PSO with optional inputs
rng('default');
outResults = Lab5_crcbqcpso(inParams,psoParams,nRuns)
%%
% % Calculation of the norm
sig = crcbgenqcsig(timeVec,10,[67,27,10]);
% Norm of signal squared is inner product of signal with itself
normSigSqrd = innerprodpsd(sig,sig,sampFreq,psdPosFreq);
% Normalize signal to specified SNR
% 
sig = 10*sig/sqrt(normSigSqrd);

%%
% Plots

figure;
hold on;
plot(timeVec,dataVec,'.');  
plot(timeVec,sig);
for lpruns = 1:nRuns
    plot(timeVec,outResults.allRunsOutput(lpruns).estSig,'Color',[51,255,153]/255,'LineWidth',4.0);
end
plot(timeVec,outResults.bestSig,'Color',[76,153,0]/255,'LineWidth',2.0);
legend('Data','Signal',...
       ['Estimated signal: ',num2str(nRuns),' runs'],...
       'Estimated signal: Best run');
disp(['Estimated parameters: a1=',num2str(outResults.bestQcCoefs(1)),...
                             '; a2=',num2str(outResults.bestQcCoefs(2)),...
                             '; a3=',num2str(outResults.bestQcCoefs(3))]);
xlabel('Times(s)')
ylabel('Amplitude')