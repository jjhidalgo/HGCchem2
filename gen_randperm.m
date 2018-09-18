function [perm,var_lnk_actual]=gen_randperm(lx,ly,KX2,KY2)
%
% This functions generates fields of mean 0 and var = 1.
%
var_lnk = 1.;

i = sqrt(-1);
[Ny,Nx] = size(KX2);
dkx = sqrt(KX2(1,2));
dky = sqrt(KY2(2,1));
%uncomment next 1 line to obtain unique random numbers everytime matlab is started
%RandStream.setDefaultStream(RandStream('mt19937ar','seed',sum(100*clock)));

%%%%Spectral density functions%%%%
%Whittle-A spectrum, isotropic medium
%a = pi/(4*sqrt(lx*ly));
%S = (2*var_lnk*a*a/pi)*( (KX2+KY2) ./ ((a*a+KX2+KY2).^3) );  

%Gaussian spectrum, Random Field Generator, Ruan and McLaughlin, Adv Water Res. 1998,
%S = (1/2/pi)*var_lnk*lx*ly*exp(-0.5*(lx^2)*(KX2) - 0.5*(ly^2)*(KY2));

%Spectrum of exponential autocovariance, Gelhar & Axness, WRR 1983
%
S = pi*pi*(1. + (lx^2).*KX2 + (ly^2).*KY2).^2;
S = var_lnk*lx*ly./S;
%Spectrum of modified exp autocovariance, Gelhar & Axness, WRR 1983
%S = (2/pi)*var_lnk*lx*ly;
%S = S./( (1+(lx^2).*KX2+(ly^2).*KY2).^3 ); 

H = S.^(0.5); 
theta = 2*pi*rand(Ny,Nx); %random phase angle

dZ = H.*exp(i*theta).*sqrt(dkx*dky)*Nx*Ny;
lnK = ifft2(dZ); %log(hyd. cond.)
K1 = sqrt(2)*real(lnK);
K2 = sqrt(2)*imag(lnK);
var_lnk_actual = var(reshape(K1,Ny*Nx,1));

K1 = exp(K1);
K2 = exp(K2);

%choose either K1 or K2
perm = K1;
