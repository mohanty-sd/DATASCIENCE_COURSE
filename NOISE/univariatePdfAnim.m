%% Animate the trials for a univariate pdf

%Total number of trials
nTrials = 10000;

%Conduct trials for a random variable whose pdf is the Normal pdf
pdfMean = 0;
pdfStdev = 1.0;

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
for lp = 1:nTrials
    x = randn()*pdfStdev + pdfMean;
    %Event index
    evntIndx = find(evntBndryLow <= x, 1, 'last' );
    evntCrv(evntIndx) = evntCrv(evntIndx) + 1;
    plot(x, -max(evntCrv/lp)/20, '*')
    hold on;
    bar((evntBndryHi+evntBndryLow)/2, pdf('norm',(evntBndryHi+evntBndryLow)/2, pdfMean,pdfStdev)*evntSz);
    bar((evntBndryHi+evntBndryLow)/2, evntCrv/lp);
    hold off;
    axis([rangeVal, -max(evntCrv/lp)/10, max(evntCrv/lp)]);
    title(num2str(lp));
    drawnow;
    %Use the pause to set up screen recording
    if lp == 1
        pause(20);
    end
    %Animation
%     frame = getframe(h);
%     im = frame2im(frame);
%     [imind,cm] = rgb2ind(im,256); 
%     % Write to the GIF File 
%     imwrite(imind,cm,fileName,'gif','WriteMode','append');
end