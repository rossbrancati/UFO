function [ netA ] = copAccel( ml, ap, fs )
%COPACCEL Returns net acceleration of COP.
%
% ARGUMENTS
% ML - ML COP coordinates
% AP - AP COP coordinates
% fs - sampling rate (Hz)
%
% RETURNS
% net

% ML and AP COP acceleration
mlA = cent_diff3(cent_diff3(ml,1/fs),1/fs); 
apA = cent_diff3(cent_diff3(ap,1/fs),1/fs);

% Net acceleration of the COP
netA = mean(sqrt(mlA.^2 + apA.^2));

end % End function.

