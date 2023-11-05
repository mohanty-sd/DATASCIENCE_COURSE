function [symmMassRatio,totalMass,symmMassRatioInv] = pn2chirp_masses2etam(m1, m2)
%Compute eta, M, eta^{-1} for masses M1, M2, (Kg) 
%[eta,M,etaInv] = PN2CHIRP_MASSES2ETAM(M1,M2)
%Convert masses M1 and M2 to the symmetric mass ratio (eta),  total mass
%(M), and 1/eta. These quantities are required in converting M1, M2 to
%chirp times. M1 and M2 must be in Kg. For ease of conversion from solar
%masses to Kg: 1 solar mass = 1.9891e30 Kg.

%Soumya D. Mohanty, Apr'23

totalMass = m1+m2;
redMass = m1*m2/totalMass;
symmMassRatio = redMass/totalMass;
symmMassRatioInv = 1/symmMassRatio;
