%% Animate convolution
nSamples = 100;
samplingFreq = 100;
t = (0:(nSamples-1))/samplingFreq;
sig1 = [zeros(1,50),-(0:24)*10/25+10,zeros(1,25)];
%Create more peaks
sig1 = sig1 + circshift(sig1, -30);
sig2 = [(0:24)*10/25, zeros(1,75)];
s12conv = zeros(1,nSamples);
h=figure;
fileName = 'convdemo.gif';
frame = getframe(h);
im = frame2im(frame);
[imind,cm] = rgb2ind(im,256);
imwrite(imind,cm,fileName,'gif', 'Loopcount',inf);
for lp = 1:100
    %Plot both sig1 and sig2
    subplot(3,1,1)
    plot(t,sig1,t,circshift(sig2,lp));
    axis([0,1,0,10]);
    %Plot the product of sig1 and sig2
    subplot(3,1,2)
    plot(t, sig1.*circshift(sig2,lp));
    axis([0,1,-10,100]);
    %Plot the sum of the product of sig1 and sig2
    subplot(3,1,3)
    s12conv(lp)=sum(sig1.*circshift(sig2,lp))/samplingFreq;
    plot(t,s12conv);
    axis([0,1,0,10]);
    %Animation
    frame = getframe(h);
    im = frame2im(frame);
    [imind,cm] = rgb2ind(im,256); 
    % Write to the GIF File 
    imwrite(imind,cm,fileName,'gif','WriteMode','append');
end
