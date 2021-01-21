%% Finite difference scheme for SHO
% The time interval for finite difference
sampIntrvl = 0.1;
% The number of samples in the output signal
nSamples = 10000;
%Spring constant
k = 4*pi^2*0.05^2;

timeVec = (0:(nSamples-1))*sampIntrvl;

%Evolve using an IIR filter
commonFac1 = 1/(k+sampIntrvl^(-2));
commonFac2 = 1/sampIntrvl^2;
%Filter coefficients
a = [1,-2*commonFac1*commonFac2, commonFac1*commonFac2];
b = commonFac1;

%Impulse response 1
forceStrt = 500; %Sample at which impulse appears
forceVec = zeros(size(timeVec)); %Impulse is zero everywhere ...
forceVec(forceStrt)=1;%... except at forceStrt
outVec = filter(b,a,forceVec); %Output 
figure;
hold on;
plot(timeVec,outVec);

%Impulse response 2: Different impulse time
forceVec(:)=0;
forceVec(floor(2*forceStrt))=1; 
outVec = filter(b,a,forceVec);
plot(timeVec,outVec);
axis tight;
xlabel('Time');
ylabel('Response');

%Response to WGN force starting abruptly
forceVec = randn(size(timeVec));
forceVec(1:forceStrt)=0;
outVec = filter(b,a,forceVec);
figure;
plot(timeVec,forceVec/norm(forceVec))
hold on;
plot(timeVec,outVec/norm(outVec), 'LineWidth',2.0);
figure
pwelch(outVec,1024,[],[],1/sampIntrvl);





