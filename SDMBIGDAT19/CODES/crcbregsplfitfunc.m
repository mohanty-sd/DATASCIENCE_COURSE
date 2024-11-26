function [fitVal,varargout] = crcbregsplfitfunc(xVec,params)
%fitness function for regression spline 
%F = CRCBREGSPLFITFUNC(X,P) 
%Computes the L2 norm of the difference between a data vector and a
%candidate spline represented as a linear combination of b-spline
%functions. X is a row vector specifying the breakpoints in terms of the CL
%scheme parameters. X is standardized such that each element is in [0,1].
%The CL scheme is used to convert the parameters into actual breakpoint
%locations. Given X, the best coefficients are found for the b-spline
%functions and the corresponding linear combination of b-splines is used to
%compute the L2 norm of the residual, returned as F.  The fields of P are
%'dataY', 'dataX', 'rmin', and 'rmax'.
%The fields P.rmin and P.rmax  are used
%to convert X(i,j) internally before computing the fitness:
%X(:,j) -> X(:,j)*(rmax(j)-rmin(j))+rmin(j).
%
%If X is a R-by-N matrix, then the fitness is evaluated for each row of X.
%F contains the fitness values evaluated for each row of X.
%
%[F,RC,C,S]=CRCBREGSPLFITFUNC(X,P)
%For each row of X and correspoinding rows in RC, C, and S: returns the
%real breakpoint locations in RC, the best-fit b-spline
%coefficients in C, and the estimated spline itself in S.

%Soumya D. Mohanty
%June, 2012
%May 2018: Adapted from REGRESSIONCODES/VKNTSDMBSPLINEFIT

%Number of rows= number of independent spline candidates
[nVecs,nBrks] = size(xVec);
%Number of interior break points after excluding the end break points
nIntBrks = nBrks - 2;
if nIntBrks < 3
    error('Number of interior breakpoints must be >= 3');
end
%One fitness value for each row
fitVal = zeros(1,nVecs);

%Check for out of bound coordinates and flag them
validPts = crcbchkstdsrchrng(xVec);
%Set fitness for invalid points to infty
fitVal(~validPts)=inf;
xVec(validPts,:) = s2rv(xVec(validPts,:),params);

%Data values
dataX = params.dataX;
dataY = params.dataY;
smplIntrvl = dataX(2)-dataX(1);
%The number of b-splines is = #interior break pts + 2 end break points - 4.
nBsplines = nIntBrks-2;
%Number of samples in the data
nSamples = length(dataX);
%Obtain the breakpoints
brkPts = zeros(nVecs,nIntBrks+2);
for lpc = 1:nVecs
    if validPts(lpc)
        strtBrkPt = (dataX(end)-dataX(1))*xVec(lpc,1)+dataX(1);
        stopBrkPt = (dataX(end)-strtBrkPt)*xVec(lpc,end)+strtBrkPt;
        brkPts(lpc,:) = clschemepriv(strtBrkPt,xVec(lpc,2:(end-1)),stopBrkPt);
        %Heal the breakpoints if they are closer than the sampling interval
        brkPts(lpc,:) = healtstampspriv(dataX(1),dataX(end),smplIntrvl,brkPts(lpc,:));
        if brkPts(lpc,1) < dataX(1) || brkPts(lpc,end) > dataX(end)
            warning('Healing the break points did not work!');
        end
    end
end

%Allocate storage
ppsig = zeros(size(dataX));
bVals = zeros(nBsplines,nSamples);
gMat = zeros(nBsplines);
coeffMat = zeros(nBsplines,nVecs);
brkPts4bspl = zeros(1,5);
%For each input location ...
for lpc = 1:nVecs
    if validPts(lpc)
        %Generate B-splines
        for lpc2 = 1:nBsplines
            brkPts4bspl = brkPts(lpc,lpc2:(lpc2+4));
            pp = bspline(brkPts4bspl);
            strtIndx = min([max([ceil(brkPts4bspl(1)/smplIntrvl),1]),nSamples]);
            stopIndx = max([1,min([floor(brkPts4bspl(end)/smplIntrvl),nSamples])]);
            bVals(lpc2,:) = 0;
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
        coeffMat(:,lpc) = gMat'\fMat;
        %Generate the candidate signal
        ppsig = coeffMat(:,lpc)'*bVals;
        %Construct the L2 norm of the residual
        fitVal(lpc) = norm(dataY-ppsig);
    end
end

%Optional output
if nargout > 1
    %Real coordinates (internal knots only)
    varargout{1} = brkPts;
    if nargout > 2
        varargout{2} = coeffMat';
        if nargout > 3
            estSig = zeros(nVecs,nSamples);
            for lpc = 1:nVecs
                if validPts(lpc)                    
                    %Generate B-splines
                    for lpc2 = 1:nBsplines
                        brkPts4bspl = brkPts(lpc,lpc2:(lpc2+4));
                        pp = bspline(brkPts4bspl);
                        strtIndx = min([max([ceil(brkPts4bspl(1)/smplIntrvl),1]),nSamples]);
                        stopIndx = max([1,min([floor(brkPts4bspl(end)/smplIntrvl),nSamples])]);
                        bVals(lpc2,:) = 0;
                        bVals(lpc2,strtIndx:stopIndx) = fnval(pp,dataX(strtIndx:stopIndx));
                    end
                    %Generate the candidate signal
                    estSig(lpc,:) = coeffMat(:,lpc)'*bVals;
                end
            end
            varargout{3} = estSig;
        end
    end
end

function tLocs = clschemepriv(tmin,sclParams,tmax)
%Convert CL scheme parameters to real breakpoint locations

%Soumya D. Mohanty, Sep 2015
%Oct 2015: Modified to accept only interior scale parameters.

%Number of interior locations
nLocsIn = length(sclParams);
%Total number of locations
nLocs = nLocsIn+2;

%Get time coordinates of break points from scale parameters
tLocs = zeros(1,nLocs);
tLocs(1) = tmin;
tLocs(end) = tmax;
%last brkPts
% Breakpoints confined to [tmin,tmax] and expressed using
% C. Leung's parameterization.
%Convert scale factors to actual break point locations
rhsMat = [tLocs(1);zeros(nLocsIn,1);tLocs(end)];
fatMat = -1*eye(nLocs);
fatMat(1,1)=1;
fatMat(nLocs,nLocs) = 1;
%indices of diagonal elements
diagIndx = ((1:nLocs)-1)*nLocs+(1:nLocs);
%indices of next diagonal to the right
diagIndxR = diagIndx(2:end)-1;
diagIndxL = diagIndx(1:(end-1))+1;
fatMat(diagIndxR) = [0,sclParams];
fatMat(diagIndxL) = [1-sclParams,0];
%Solve for break point time coordinates
tLocs = fatMat\rhsMat;
%To eliminate any numerical errors, hard set the end break
%points
tLocs(1) = tmin;
tLocs(end) = tmax;
tLocs = tLocs';

function hldTVals = healtstampspriv(tmin,tmax,minGapTime,ckTVals)
%Rectify time stamps to ensure minimum gap
%T = HEALTSTAMPSPRIV(T1,T2,M,V)
%Return a vector T, with the same length as V, containing a new set of time
%values such that there is a minimum gap between consecutive values. T1 and
%T2 are the minimum and maximum time boundaries and M is the desired
%minimum gap.

%Soumya D. Mohanty, July 2013

tol = 1e-4*minGapTime;

%The minimum gap must be consistent with the time interval boundaries
if length(ckTVals)*minGapTime > tmax-tmin
    error('Bad minimum gap');
end

%Initial assumption is that the time values are OK
hldTVals = ckTVals;
if ~any(minGapTime-diff([tmin,hldTVals,tmax])>tol)
    return;
end

%Distances to left and right particles
nPoints = length(hldTVals);
while any(minGapTime-diff([tmin,hldTVals,tmax])>tol)
    ld = hldTVals-[tmin,hldTVals(1:(end-1))];
    rd = [hldTVals(2:end),tmax]-hldTVals;
    ld = min([ld;minGapTime*ones(1,nPoints)]);
    rd = min([rd;minGapTime*ones(1,nPoints)]);
    %"Force": positive means move to the right (more gap on the right than
    %left) and negative means move to the left (more gap on the left than
    %right)
    frc = rd-ld;
    %Exreme points cannot move closer to the boundaries if the existing gap
    %is already <= minimum gap
    if (minGapTime-ld(1)) > tol && frc(1) < 0
        frc(1)=0;
    end
    if (minGapTime-rd(end)) > tol && frc(end) > 0
        frc(end) = 0;
    end
    %update positions
    hldTVals = sort(hldTVals+frc);
end