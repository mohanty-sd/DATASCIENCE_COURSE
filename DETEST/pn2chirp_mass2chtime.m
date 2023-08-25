function chrpTVec = pn2chirp_mass2chtime(m1, m2, fMin)
%C = PN2CHIRP_MASS2CHTIME(M1, M2, Fmin)
%Compute the chirp time parameters of a 2PN chirp for masses M1, M2, (Kg) 
%and minimum frequency cutoff Fmin (Hz). For ease of conversion from solar
%masses to Kg: 1 solar mass = 1.9891e30 Kg.

%Soumya D. Mohanty, Nov'22
%Apr'23: Modified to use functions for generating prefactors

%G*pi*fmin/c^3
G = 6.67430e-11; %SI units
c = 299792458; %m/sec
geomFac = G*pi*fMin/c^3;

constVals = mass2chtime_constVals(fMin,geomFac);

%Compute symmetric mass ratio (eta), total Mass (M), eta^{-1}
totalMass = m1+m2;
redMass = m1*m2/totalMass;
symmMassRatio = redMass/totalMass;
symmMassRatioInv = 1/symmMassRatio;

chrpTVec(1) = constVals.cht0pre   * constVals.cht0f0 *...
              totalMass^(-5/3)    * symmMassRatioInv;
% preFac_tau0   =   pn2chirp_prefac_etam2tau0(fMin,geomFac);
% chrpTVec(1) = pn2chirp_etam2tau0([symmMassRatioInv, totalMass], preFac_tau0);

chrpTVec(2) = constVals.cht1pre   * constVals.cht1f0 *...
              totalMass^(-1)      * symmMassRatioInv *...
              (constVals.cht1f1   + constVals.cht1f2*symmMassRatio);
% preFac_tau1   =   pn2chirp_prefac_etam2tau1(fMin,geomFac);
% chrpTVec(2) = pn2chirp_etam2tau1([symmMassRatio, symmMassRatioInv, totalMass], preFac_tau1);

chrpTVec(3) = constVals.cht1p5pre * constVals.cht1p5f0 *...
              totalMass^(-2/3)    * symmMassRatioInv;
% preFac_tau1p5   =   pn2chirp_prefac_etam2tau1p5(fMin,geomFac);
% chrpTVec(3) = pn2chirp_etam2tau1p5([symmMassRatioInv, totalMass], preFac_tau1p5);


chrpTVec(4) = constVals.cht2pre   * constVals.cht2f0 *...
              totalMass^(-1/3)    * symmMassRatioInv *...
              (constVals.cht2f1   + constVals.cht2f2*symmMassRatio +...
               constVals.cht2f3 * symmMassRatio^2);
           
end

function constVals = mass2chtime_constVals(fMin,geomFac)
    %Compute prefactors
    fMinInv = 1/fMin;
    %Use meaningful names for the prefactors
    cht0pre = (5/(256*pi))*fMinInv;
    cht0f0 =  geomFac^(-5/3);
    preFac_tau0(1) = cht0pre;
    preFac_tau0(2) = cht0f0;

    cht1pre= (5/(192*pi))*fMinInv;
    cht1f0 = geomFac^(-1);
    cht1f1 = 743/336;
    cht1f2 = 11/4;
    %Assign prefactors to output array
    preFac_tau1(1) = cht1pre;
    preFac_tau1(2) = cht1f0;
    preFac_tau1(3) = cht1f1;
    preFac_tau1(4) = cht1f2;

    cht1p5pre = (1/8)*fMinInv;
    cht1p5f0 = geomFac^(-2/3);
    %Assign prefactors to output array
    preFac_tau1p5(1) = cht1p5pre;
    preFac_tau1p5(2) = cht1p5f0;

    cht2pre=(5/(128*pi))*fMinInv;
    cht2f0 = geomFac^(-1/3);
    cht2f1 = 3058673/1016064;
    cht2f2 = 5429/1008;
    cht2f3 = 617/144;
    preFac_tau2(1) = cht2pre;
    preFac_tau2(2) = cht2f0;
    preFac_tau2(3) = cht2f1;
    preFac_tau2(4) = cht2f2;
    preFac_tau2(5) = cht2f3;
    
    constVals = struct(...
                      'cht0pre'  , preFac_tau0(1),...
                      'cht0f0'   , preFac_tau0(2),...
                      'cht1pre'  , preFac_tau1(1),...
                      'cht1f0'   , preFac_tau1(2),...
                      'cht1f1'   , preFac_tau1(3),...
                      'cht1f2'   , preFac_tau1(4),...
                      'cht1p5pre', preFac_tau1p5(1),...
                      'cht1p5f0' , preFac_tau1p5(2),...
                      'cht2pre'  , preFac_tau2(1),...
                      'cht2f0'   , preFac_tau2(2),...
                      'cht2f1'   , preFac_tau2(3),...
                      'cht2f2'   , preFac_tau2(4),...
                      'cht2f3'   , preFac_tau2(5));

end