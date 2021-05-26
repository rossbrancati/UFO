function [ mlR, apR ] = copRange( ml, ap )
%RANGE COP Returns range in ML and AP directions separately
%
% ARGUMENTS
% ml - ML COP coordinates
% ap - AP COP coordinates
%
% ========================================================================%

% Compute ML and AP range.
mlR = max(ml)-min(ml);
apR = max(ap)-min(ap);

end % End function.

