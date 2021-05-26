function [ path ] = copPath( ml, ap )
%COPPATH Calculates the COP path length.
%
% ARGUMENTS
% ml - ML COP coordinates
% ap - AP COP coordinates
%
% ========================================================================%

% Compute ML and AP displacements
ml_dist = diff(ml);
ap_dist = diff(ap);

% Compute net displacements.
path = sqrt( ml_dist.^2 + ap_dist.^2 );

% Sum displacements to determine path length.
path = sum(path);

end % End function.

