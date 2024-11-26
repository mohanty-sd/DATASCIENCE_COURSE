function outStruct = crcbcrdnlsplfit(dataX,dataY,nIntBrks)
% Spline fit with cardinal B-Splines
% O = CRCBCRDNSPLFIT(X,Y,N)
% Fit data with a linear combination of cardinal B-splines. Y is The data
% vector X is The time stamps of the data vector (i.e. the values of the
% independent variable). N The number of uniformly spaced *interior*
% breakpoints to use for the fit (there will always be two breakpoints at
% dataX(1) and dataX(end). 
% The output is a struct O with the following fields.
%  'estSig' : The estimated signal
%  'fitVal' : The fitness value (norm of the residual)
%  'brkPts' : The breakpoints (including end breakpoints)
%  'bsplCoefs' : The coefficients of the B-splines.


%Soumya D. Mohanty, May 2018

nSamples = length(dataX);
smplIntrvl = dataX(2) - dataX(1);

% Sanity checks
if length(dataY) ~= nSamples
    error('Inconsistent dataX and dataY');
end

% Generate all break points
nBsplines = nIntBrks-2;
if nBsplines < 1
    error('Increase the number of interior knots');
end
brkPtGap = (dataX(end)-dataX(1))/(nIntBrks+1);
brkPts = [dataX(1),(1:nIntBrks)*brkPtGap,dataX(end)];


%Preallocate storage
bVals = zeros(nBsplines,nSamples);
gMat = zeros(nBsplines);
brkPts4bspl = zeros(1,5);
%Generate B-splines
for lpc2 = 1:nBsplines
    %Extract 5 breakpoints
    brkPts4bspl = brkPts(lpc2:(lpc2+4));
    %Generate B-spline in pp form
    pp = bspline(brkPts4bspl);
    strtIndx = min([max([ceil(brkPts4bspl(1)/smplIntrvl),1]),nSamples]);
    stopIndx = max([1,min([floor(brkPts4bspl(end)/smplIntrvl),nSamples])]);
    bVals(lpc2,:) = 0;
    %Evaluate pp form for time stamps relevant to this B-spline
    bVals(lpc2,strtIndx:stopIndx) = fnval(pp,dataX(strtIndx:stopIndx));
end
%Construct the transfer matrix for this set of b-splines. The (i,p)
%element is sum_k b_i(t_k)b_p(t_k), where b_s(t) is the s'th b-spline.
for lpc2 = 1:nBsplines
    for lpc3 = lpc2:nBsplines
        gMat(lpc2,lpc3) = bVals(lpc2,:)*bVals(lpc3,:)';
        gMat(lpc3,lpc2) = gMat(lpc2,lpc3);
    end
end

%The source term
fMat = bVals*dataY';
%Solve for the coefficients
coeffMat = gMat'\fMat;
%Generate the candidate signal
ppsig = coeffMat'*bVals;
%Construct the L2 norm of the residual
fitVal = norm(dataY-ppsig);

%Output 
outStruct = struct('estSig',ppsig,...
                   'fitVal',fitVal,...
                   'brkPts',brkPts,...
                   'bsplCoefs',coeffMat');