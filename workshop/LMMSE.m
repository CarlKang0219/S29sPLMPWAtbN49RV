%Author: Alex Dytso
%Date: 12/19/2012
%Description: This function is an implemenation of the LMMS(linear minimum
%mean square error) that is used to combat ISI( intersymbol interference)
%in communication systems. 

function Xh = LMMSE(g,r,N0,N )

%g channel 
%r input signal after noise has been addded
%N0 is nois vairance
%N length of the sequeance 
% 
% g = [1 2 3 4];
% r = [1 1 1 1 1 1 1];
% N0 = 0.5;
% N = 7;


%Computing z-transforms of impulse response
gDconjTimeInv=filt(conj(fliplr(g)),1); % frequency domain repersentatin of conjugate  time inverse of g[n]
	
gD=filt(g,1); % frequence representation of g[n]
% gD
f=gDconjTimeInv/(gD*gDconjTimeInv+N0); %LMMSE filter in frequence domain
% f
[num,den]=tfdata(f,'v'); %extraction coefficient of denominator and numerator
% den
% num
%LMMSE
Xh=filter(num,den,r); % filtering input signal r

Xh=Xh(1:N);


end