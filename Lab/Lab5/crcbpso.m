function returnData=crcbpso(fitfuncHandle,nDim,varargin)
% Local-best (lbest) PSO minimizer 
% S=CRCBPSO(Fhandle,N)
% Runs local best PSO on the fitness function with handle Fhandle. If Fname
% is the name of the function, Fhandle = @(x) <Fname>(x, FP).  N is the
% dimensionality of the  fitness function.  The output is returned in the
% structure S. The field of S are:
%  'bestLocation : Best location found (in standardized coordinates)
%  'bestFitness': Best fitness value found
%  'totalFuncEvals': Total number of fitness function evaluations. This can
%                    be less than the product of the number of iterations
%                    and the number of particles since particles can leave
%                    and re-enter the search space.
%
%S=CRCBPSO(Fhandle,N,P)
%overrides the default PSO parameters with those provided in structure P.
%Set any of the fields of P to [] in order to invoke the corresponding
%default value. The fields of P are as follows.
%     'popSize': Number of PSO particles
%     'maxSteps': Number of iterations for termination
%     'c1','c2': acceleration constant
%     'maxVelocity': maximum value for each velocity component for all
%                     subsequent iterations
%     'startInertia': Starting value of inertia weight
%     'endInertia': End value of inertia at iteration# <maxSteps>
%     'boundaryCond': Set to '' for the "let them fly" boundary condition.
%                     Any other value is passed onto the fitness function
%                     for further processing. 
%     'nbrhdSz' : Number of particles in a ring topology neighborhood.
%                 Reset to 3 if less than 3.
%Setting P to [] will invoke the default values for all pso parameters.
%NOTE: The optional P argument is normally to be used only for testing and
%debugging (e.g., reduce the number of particles and/or iterations for a
%quick run). Baseline default values are hardcoded in this function.
%
%S = CRCBPSO(Fhandle,N,P,O)
%O is an integer that controls the amount of information returned in S. The
%default value of O is zero and returns S as the struct defined above.
%Progressively higher values of O increase the number of fields in S as
%listed below.
%   'allBestFit': O = 1. Best fitness values for all iterations returned as a vector.
%   'allBestLoc': O = 2. Best locations in standardized coordinates for all
%                 iterations returned as a row of a matrix. 
%
%Example:
%nDim = 5;
%fitFuncParams = struct('rmin',-5*ones(1,nDim),...
%                           'rmax',5*ones(1,nDim));
%fitFuncHandle = @(x) crcbpsotestfunc(x,fitFuncParams);
%psoOut = crcbpso(fitFuncHandle,5);

% Authors
% Soumya D. Mohanty, Dec 2018
% Adapted from LDACSchool/ldacpso.m
% 

%Baseline (also default) PSO parameters
popsize=40;
maxSteps= 2000;
c1=2;
c2=2;
max_velocity = 0.5;
dcLaw_a = 0.9;
dcLaw_b = 0.4;
dcLaw_d = 0.2;
bndryCond = '';
nbrhdSz = 3;
% add rowSeed and colSeed to describe seeding location, 0 if no seeding
nrowSeed=0;
ncolSeed=0;
%Default for the level of information returned in the output
outputLvl = 0;
returnData = struct('totalFuncEvals',[],...
                    'bestLocation',zeros(1,nDim),...
                    'bestFitness',[]);
%Override defaults if needed
nreqArgs = 2;
if nargin-nreqArgs
    for largs = 1:(nargin-nreqArgs)
        if isempty(varargin{largs})
        else
            switch largs
                case 1
                    psoParams = varargin{largs};
                    %pso parameters
                    psoParfieldNames = fieldnames(psoParams);
                    for lpfields = 1:length(psoParfieldNames)
                        fieldVal = getfield(psoParams,psoParfieldNames{lpfields});
                        if isempty(fieldVal)
                            %do nothing and retain default value
                        else
                            switch psoParfieldNames{lpfields}
                                case 'popSize'
                                    popsize = fieldVal;
                                case 'maxSteps'
                                    maxSteps = fieldVal;
                                case  'c1'
                                    c1 = fieldVal;
                                case  'c2'
                                    c2 = fieldVal;
%                                 case 'maxInitialVelocity'
%                                     max_initial_velocity = fieldVal;
                                case 'maxVelocity'
                                    max_velocity = fieldVal;
                                case 'startInertia'
                                    dcLaw_a = fieldVal;
                                case 'endInertia'
                                    %dcLaw_b is set to dcLaw_a - dcLaw_b
                                    %later but stores the endIntertia for
                                    %now
                                    dcLaw_b = fieldVal;
                                case 'boundaryCond'
                                    bndryCond = fieldVal;
                                case 'nbrhdSz'
                                    nbrhdSz = fieldVal;
                            end
                        end
                    end
                case 2
                    %Output level
                    outputLvl = varargin{largs};
                    for lpo = 1:outputLvl
                        switch lpo
                            case 1
                                returnData.allBestFit = zeros(1,maxSteps);                               
                            case 2
                                returnData.allBestLoc = zeros(maxSteps,nDim);
                            %Add more fields with additional case
                            %statements
                            otherwise
                                error('Output level > 2 not implemented');
                        end
                    end
                case 3
                    %Matrix of locations to seed the particles
                    %Matrix is in best stored in standardized coordinates
                    %Matrix element A(a,b) is the bth component of ath
                    %particle
                    seedMatrix=varargin{largs};
                    [nrowSeed,ncolSeed]=size(seedMatrix);
                    if ncolSeed>nDim
                        error('Too many coordinate parameters')
                    end
                    if nrowSeed>popsize
                        seedMatrix=seedMatrix(:,1:popsize);
                        [nrowSeed,ncolSeed]=size(seedMatrix);
                    end
                    %The idea here is that since the seeding matrix can and
                    %probably would be smaller than the particle location
                    %matrix, it would be easier to generate the location
                    %matrix and then graft our pregenerated matrix onto it
            end
        end
    end
end
%Update constants involved in inertia decay 
dcLaw_c = maxSteps;
dcLaw_b = dcLaw_a - dcLaw_b;

%Number of left and right neighbors. Even neighborhood size is split
%asymmetrically: More right side neighbors than left side ones.
nbrhdSz = max([nbrhdSz,3]);
leftNbrs = floor((nbrhdSz-1)/2);
rightNbrs = nbrhdSz-1-leftNbrs;

%Information about each particle stored as a row of a matrix ('pop').
%Specify which column stores what information.
%(The fitness function for matched filtering is SNR, hence the use of 'snr'
%below.)

partCoordCols = 1:nDim; %Particle location
partVelCols = (nDim+1):2*nDim; %Particle velocity
partPbestCols = (2*nDim+1):3*nDim; %Particle pbest
partFitPbestCols = 3*nDim+1; %Fitness value at pbest
partFitCurrCols = partFitPbestCols+1; %Fitness value at current iteration
partFitLbestCols = partFitCurrCols+1; %Fitness value at local best location
partInertiaCols = partFitLbestCols+1; %Inertia weight
partLocalBestCols = (partInertiaCols+1):(partInertiaCols+nDim); %Particles local best location
partFlagFitEvalCols = partLocalBestCols(end)+1; %Flag whether fitness should be computed or not
partFitEvalsCols = partFlagFitEvalCols+1; %Number of fitness evaluations

nColsPop = length([partCoordCols,partVelCols,partPbestCols,partFitPbestCols,...
                   partFitCurrCols,partFitLbestCols,partInertiaCols,partLocalBestCols,...
                   partFlagFitEvalCols,partFitEvalsCols]);
pop=zeros(popsize,nColsPop);

% Best value found by the swarm over its history
gbestVal = inf;  
% Location of the best value found by the swarm over its history
gbestLoc = 2*ones(1,nDim);
% Best value found by the swarm at the current iteration
bestFitness = inf;
pop(:,partCoordCols)=rand(popsize,nDim);
%mount on our seeded locations
if (nrowSeed>0) & (ncolSeed>0)
    pop(1:nrowSeed,1:ncolSeed)=seedMatrix;
end
pop(:,partVelCols)= -pop(:,partCoordCols)+rand(popsize,nDim);
pop(:,partPbestCols)=pop(:,partCoordCols);
pop(:,partFitPbestCols)= inf;
pop(:,partFitCurrCols)=0;
pop(:,partFitLbestCols)= inf;
pop(:,partLocalBestCols) = 0;
pop(:,partFlagFitEvalCols)=1;
pop(:,partInertiaCols)=0;
pop(:,partFitEvalsCols)=0;

%Start PSO iterations ...
for lpc_steps=1:maxSteps
    %Evaluate particle fitnesses under ...
    if isempty(bndryCond)
        %Invisible wall boundary condition
        fitnessValues = fitfuncHandle(pop(:,partCoordCols));
    else
        %Special boundary condition (handled by fitness function)
        [fitnessValues,~,pop(:,partCoordCols)] = fitfuncHandle(pop(:,partCoordCols));
    end
    %Fill pop matrix ...
    for k=1:popsize
        pop(k,partFitCurrCols)=fitnessValues(k);
        computeOK = pop(k,partFlagFitEvalCols);
        if computeOK
            funcCount = 1;
        else
            funcCount = 0;
        end
        pop(k,partFitEvalsCols)=pop(k,partFitEvalsCols)+funcCount;
        if pop(k,partFitPbestCols) > pop(k,partFitCurrCols)
            pop(k,partFitPbestCols) = pop(k,partFitCurrCols);
            pop(k,partPbestCols) = pop(k,partCoordCols);
        end
    end
    %Update gbest
    [bestFitness,bestParticle]=min(pop(:,partFitCurrCols));
    if gbestVal > bestFitness
        gbestVal = bestFitness;
        gbestLoc = pop(bestParticle,partCoordCols);
        pop(bestParticle,partFitEvalsCols)=pop(bestParticle,partFitEvalsCols)+funcCount;
    else
    end
    %Local bests ...
    for k = 1:popsize
        %Get indices of neighborhood particles
        ringNbrs = [(k-leftNbrs):(k-1),k,(k+1):(k+rightNbrs)];
        adjstIndx = ringNbrs<1;
        ringNbrs(adjstIndx) = ringNbrs(adjstIndx)+popsize;
        adjstIndx = ringNbrs>popsize;
        ringNbrs(adjstIndx) = ringNbrs(adjstIndx) - popsize;
        
        %Get local best in neighborhood
        [~,lbestPart] = min(pop(ringNbrs,partFitCurrCols));
        lbestTruIndx = ringNbrs(lbestPart);
        lbestCurrSnr = pop(lbestTruIndx,partFitCurrCols);
        
        if lbestCurrSnr < pop(k,partFitLbestCols)
            pop(k,partFitLbestCols) = lbestCurrSnr;
            pop(k,partLocalBestCols) = pop(lbestTruIndx,partCoordCols);
        end
    end
    %Inertia decay
    inertiaWt = max(dcLaw_a-(dcLaw_b/dcLaw_c)*lpc_steps,dcLaw_d);
    %Velocity updates ...
    for k=1:popsize
        pop(k,partInertiaCols)=inertiaWt;
        partInertia = pop(k,partInertiaCols);
        chi1 = diag(rand(1,nDim));
        chi2 = diag(rand(1,nDim));
        pop(k,partVelCols)=partInertia*pop(k,partVelCols)+...
            c1*(pop(k,partPbestCols)-pop(k,partCoordCols))*chi1+...
            c2*(pop(k,partLocalBestCols)-pop(k,partCoordCols))*chi2;
        maxvBustCompPos = find(pop(k,partVelCols) > max_velocity);
        maxvBustCompNeg = find(pop(k,partVelCols) < -max_velocity);
        if ~isempty(maxvBustCompPos)
            pop(k,partVelCols(maxvBustCompPos))= max_velocity;
        end
        if ~isempty(maxvBustCompNeg)
            pop(k,partVelCols(maxvBustCompNeg))= -max_velocity(1);
        end
        pop(k,partCoordCols)=pop(k,partCoordCols)+pop(k,partVelCols);
        if any(pop(k,partCoordCols)> 1 | ...
                pop(k,partCoordCols)< 0)
            pop(k,partFitCurrCols)= inf;
            pop(k,partFlagFitEvalCols)= 0;
        else
            pop(k,partFlagFitEvalCols)=1;
        end
    end
    
    %Record extended output if needed
    for lpo = 1:outputLvl
        switch lpo
            case 1
                returnData.allBestFit(lpc_steps) = gbestVal;
            case 2
                returnData.allBestLoc(lpc_steps,:) = gbestLoc;
            %Add more fields with additional case
            %statements
        end
    end
end

actualEvaluations = sum(pop(:,partFitEvalsCols));

%Prepare main output
returnData.totalFuncEvals = actualEvaluations;
returnData.bestLocation = gbestLoc;
returnData.bestFitness = gbestVal; 





