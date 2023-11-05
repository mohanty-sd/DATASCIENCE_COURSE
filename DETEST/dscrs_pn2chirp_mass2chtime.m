function [chrpTVec,varargout] = dscrs_pn2chirp_mass2chtime(m1, m2, fMin, varargin)
%C = DSCRS_PN2CHIRP_MASS2CHTIME(M1, M2, Fmin)
%Compute the chirp time parameters of a 2PN chirp for masses M1, M2, (Solar masses) 
%and minimum frequency cutoff Fmin (Hz). For ease of conversion from solar
%masses to Kg: 1 solar mass = 1.9891e30 Kg.
%
%C = DSCRS_PN2CHIRP_MASS2CHTIME(M1, M2, Fmin, P)
%Overrides the calculation of various constants with the values supplied in
%structure P. (Setting P to '[]' will invoke calculation of the constants.)
%The fields of P are:
%   'common': The constant G*pi*Fmin/c^3 common to all chirp times
%   'cht0pre': chirp time tau_0 prefactor (5/(256*pi))*Fmin^-1
%   'cht0f0': (G*pi*Fmin/c^3)^(-5/3)
%   'cht1pre': chirp time tau_1 prefactor (5/(192*pi))*Fmin^-1
%   'cht1f0': (G*pi*Fmin/c^3)^-1
%   'cht1f1: 743/336
%   'cht1f2: 11/4
%   'cht1p5pre': chirp time tau_1.5 prefactor (1/8)*Fmin^-1
%   'cht1p5f0: (G*pi*Fmin/c^3)^(-2/3)
%   'cht2pre': chirp time tau_2 prefactor (5/(128*pi))*Fmin^-1
%   'cht2f0' (G*pi*Fmin/c^3)^(-1/3)
%   'cht2f1': 3058673/1016064
%   'cht2f2': 5429/1008
%   'cht2f3': 617/144
%Note that one can send other values for these constants, allowing
%flexibility for non-physical waveform generation. A more mundane use of P
%would be to supply the correct pre-computed constants for computational
%efficiency when calling this function repeatedly. The correct constants
%can be generated using the family of functions PN2CHIRP_PREFAC_ETAMUM2<X>
%where X is tau0, tau1, tau1p5, or tau2.
%
%[C,Pc] =  DSCRS_PN2CHIRP_MASS2CHTIME(M1, M2, Fmin, P)
%Returns the structure Pc, a copy of the filled-in P. This can be used to
%generate the constants for use in subsequent calls to this function.

%Soumya D. Mohanty, Nov'22
%Apr'23: Modified to use functions for generating prefactors
%Nov 5, 2023: Added the token 'dscrs_' to the function name as it was
%conflicting with the same function in MATLABCODES/signals. We are using a
%copy of the latter in DATASCIENCE_COURSE in order to not expose the
%private MATLABCODES when sharing DATASCIENCE_COURSE in the GW data
%analysis schools.

%Convert masses to Kg
solMass = 1.9891e30; %Kg
m1 = m1*solMass;
m2 = m2*solMass;

genConst = 1;

%G*pi*fmin/c^3
geomFac = dscrs_pn2chirp_geomfac(fMin);

if nargin > 4
    constVals = varargin{1};
    if ~isempty(constVals)
        genConst = 0;
    end
end

if genConst
    %Constants need to be computed
    constVals = mass2chtime_constVals(fMin,geomFac);
end

%Compute symmetric mass ratio (eta), total Mass (M), eta^{-1}
[symmMassRatio,totalMass,symmMassRatioInv] = dscrs_pn2chirp_masses2etam(m1, m2);

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
% disp(constVals(:));
% disp([totalMass^(-1/3), symmMassRatioInv, symmMassRatio, symmMassRatio^2]');
% preFac_tau2   =   pn2chirp_prefac_etam2tau2(fMin,geomFac);
% chrpTVec(4) = pn2chirp_etam2tau2([symmMassRatio, symmMassRatioInv, totalMass], preFac_tau2);

           
if nargout > 1
    varargout{1} = constVals;
end
end

function constVals = mass2chtime_constVals(fMin,geomFac)
    %Compute prefactors
    preFac_tau0   =   dscrs_pn2chirp_prefac_etam2tau0(fMin,geomFac);
    preFac_tau1   =   dscrs_pn2chirp_prefac_etam2tau1(fMin,geomFac);
    preFac_tau1p5 =   dscrs_pn2chirp_prefac_etam2tau1p5(fMin,geomFac);
    preFac_tau2   =   dscrs_pn2chirp_prefac_etam2tau2(fMin,geomFac);
    
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