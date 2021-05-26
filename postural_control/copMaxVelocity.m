function [ max_ap, max_ml, max_net ] = copMaxVelocity( ml, ap, fs )
%COP_EXCURSION Returns maximum ML, AP, and net excursion of the CoP
%
% ARGUMENTS
% ml - ML COP coordinates
% ap - AP COP coordinates
% fs - sampling frequency (Hz)

% ========================================================================%

%ML and AP velocity
mlV = cent_diff3( ml, 1/fs);
apV = cent_diff3( ap, 1/fs);

% Maximum AP velocity
max_ap = max(apV);

% Maximum ML velocity
max_ml = max(mlV);

% Maximum net velocity
max_net = max(sqrt(mlV.^2 + apV.^2));

end %end function
