function [ cop_x, cop_y ] = cop( fx, fy, fz, mx, my, dz )
% Computes ML and AP center-of-pressure from six-channel (3 forces,
% 3 moments) force plate.
%
% fx - ML ground reaction force (N)
% fy - AP ground reaction force (N)
% fz - Vertical ground reaction force (N)
% mx - moment about x-axis (Nmm)
% my - moment about y-axis (Nmm)
% dz - vertical distance between surface and force plate origin (mm)
%=========================================================================%


% Sets dz value to the force plate coordinate center heightin LAMB 203.
% **NOTE: You must specify dz if you are using a different force plate.
if nargin==5
   dz=-39.6; 
end

% Compute ML and AP CoP coordinates.
cop_x = (( -1 * ( my + fx .* dz ) ) ./ fz);
cop_y = (( mx - fy .* dz ) ./ fz);

end %end function

