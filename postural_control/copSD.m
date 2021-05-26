function [ sd_ml, sd_ap ] = copSD( ml, ap )
%COPSD Returns standard deviation in ML and AP directions separately.
%
% ARGUMENTS
% ml - ML COP coordinates
% ap - AP COP coordinates
%
% ========================================================================%

% Compute ML and AP standard deviations.
sd_ml = sqrt(mean(((ml-mean(ml)).^2)));
sd_ap = sqrt(mean(((ap-mean(ap)).^2)));

end % End function.

