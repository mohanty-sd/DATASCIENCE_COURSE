function geomFac = pn2chirp_geomfac(fmin)
%Return G*pi*fmin/c^3
%C = PN2CHIRP_GEOMFAC(Fmin)
%Returns G*pi*Fmin/c^3, where G and c are the gravitational constant and
%speed of light, respectively, and Fmin is the low frequency cutoff used in
%the definition of the restricted 2PN waveform.

%Soumya D. Mohanty, Apr 2023

G = 6.67430e-11; %SI units
c = 299792458; %m/sec

geomFac = G*pi*fmin/c^3;