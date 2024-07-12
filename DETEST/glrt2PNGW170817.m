function [fitVal,varargout] = glrt2PNGW170817(xVec,params)
%GLRT with restricted 2PN templates for GW170817 data from L1
%F = GLRT2PNGW170817(X,P)
%Compute the negative of the 2PN GLRT fitness function for the data given
%in L-L1_LOSC_CLN_16_V1-1187007040-2048_DtrndWhtnBndStpDnsmpl.hdf5 for each
%row of X.  The fitness values are returned in F. X is standardized, that
%is 0<=X(i,j)<=1. 
% 
%The structure P has two arrays P.rmin and P.rmax that are used to
%convert X(i,j) internally to actual coordinate values before computing
%fitness: X(:,j) -> X(:,j)*(rmax(j)-rmin(j))+rmin(j). Here rmin(1) and
%rmin(2) are the minimum values (in solar mass) of the two binary component
%masses. Similarly, rmax(1) and rmax(2) are the corresponding maximum mass
%values. 
% 
%The rest of the fields in P are as follows.
%   dataVec_fft: The whitened data DFT
%   dataVecWhtTF: The whitening transfer function for positive DFT
%   frequencies
%   Fs: The sampling frequency (Hz)
%   fMin: The low frequency cutoff (Hz)
%   fMax: The plunge cutoff (Hz)
%
%For standardized coordinates, F = infty if a point X(i,:) falls
%outside the hypercube defined by 0<=X(i,j)<=1.
%
%[F,R] =  GLRT2PNGW170817(X,P)
%returns the real coordinates in R. 
%
%[F,R,Xp] = GLRT2PNGW170817(X,P)
%Returns the standardized coordinates in Xp. This option is to be used when
%there are special boundary conditions (such as wrapping of angular
%coordinates) that are better handled by the fitness function itself.

%Soumya D. Mohanty, July 2024

%rows: points
%columns: coordinates of a point
[nrows,~]=size(xVec);

%storage for fitness values
fitVal = zeros(nrows,1);
validPts = ones(nrows,1);

%Check for out of bound coordinates and flag them
validPts = crcbchkstdsrchrng(xVec);
%Set fitness for invalid points to infty
fitVal(~validPts)=inf;
%Convert valid points to actual locations
xVec(validPts,:) = s2rv(xVec(validPts,:),params);

sigParams = struct('mass1',[],...
                   'mass2', [],...
                   'fMin', params.fMin,...
                   'fMax', params.fMax,...
                   'winName', '');
nSmpls = length(params.dataVec_fft);
mfltOutVec = zeros(1,nSmpls);
for lpc = 1:nrows
    if validPts(lpc)
    % Only the body of this block should be replaced for different fitness
    % functions
        x = xVec(lpc,:); %These are the masses of the binary components
        sigParams.mass1 = x(1);
        sigParams.mass2 = x(2);
        %Matched filter output
        mfltOutVec = mfltr(params.dataVec_fft,params.dataVecWhtTF,params.Fs,sigParams);
        %The PSO code is for minimization, so return the negative of the
        %fitness value (and ensure that 
        fitVal(lpc) = -max(mfltOutVec);
    end
end

%Return real coordinates if requested
if nargout > 1
    varargout{1}=xVec;
    if nargout > 2
        varargout{2} = r2sv(xVec,params);
    end
end
