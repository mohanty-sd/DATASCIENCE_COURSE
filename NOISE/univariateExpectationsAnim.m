%% Animate the trials for a univariate pdf

%Total number of trials
nTrials = 10000;

%Conduct trials for a random variable whose pdf is the Normal pdf
pdfMean = 0;
pdfStdev = 2.0;

%Size of events
evntSz = 0.05;
%range of trial values to considers
rangeVal = [-5,5];
%Events
evntBndryLow = rangeVal(1):evntSz:(rangeVal(2)-evntSz);
evntBndryHi = evntBndryLow + evntSz;
%Curve showing the fraction of trials from each event
evntCrv = zeros(1, length(evntBndryLow));

h=figure;
% fileName = 'univariatePdfDemo.gif';
% frame = getframe(h);
% im = frame2im(frame);
% [imind,cm] = rgb2ind(im,256);
% imwrite(imind,cm,fileName,'gif', 'Loopcount',inf);
sampleMean = 0;
sampleStdev = 0;
pause(10);
for lp = 1:nTrials
    x = randn()*pdfStdev + pdfMean;
    sampleMean = sampleMean + x;
    sampleStdev = sampleStdev + x^2;
    %Event index
    evntIndx = find(evntBndryLow <= x, 1, 'last' );
    evntCrv(evntIndx) = evntCrv(evntIndx) + 1;
    plot(x, -max(evntCrv/lp)/20, '*')
    hold on;
    bar((evntBndryHi+evntBndryLow)/2, pdf('norm',(evntBndryHi+evntBndryLow)/2, pdfMean,pdfStdev)*evntSz);
    bar((evntBndryHi+evntBndryLow)/2, evntCrv/lp);
    %True mean
    line([pdfMean,pdfMean],[-max(evntCrv/lp)/10,max(evntCrv/lp) ],'LineStyle','--');
    %Sample mean
    sm = sampleMean/lp;
    line([sm, sm],[-max(evntCrv/lp)/10,max(evntCrv/lp) ],'LineStyle','--','Color',[0,1,0],'LineWidth',2.0);
    %True stdev
    line([pdfMean-pdfStdev/2, pdfMean+pdfStdev/2],[-max(evntCrv/lp)/25,-max(evntCrv/lp)/25],'LineStyle',':','Color',[0,0,1],'LineWidth',4.0);
    %Sample stdev
    st = sqrt(sampleStdev/lp-sm^2);
    line([sm-st/2, sm+st/2],[-max(evntCrv/lp)/25,-max(evntCrv/lp)/25],'LineStyle',':','Color',[1,0,0],'LineWidth',4.0);
    %Show expectations
    hold off;
    axis([rangeVal, -max(evntCrv/lp)/10, max(evntCrv/lp)]);
    title(num2str(lp));
    drawnow;
    %Animation
%     frame = getframe(h);
%     im = frame2im(frame);
%     [imind,cm] = rgb2ind(im,256); 
%     % Write to the GIF File 
%     imwrite(imind,cm,fileName,'gif','WriteMode','append');
end