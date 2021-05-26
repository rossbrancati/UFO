function [ max_ap, max_ml, max_net ] = copMaxExcursion( ml, ap, fs )
%COP_EXCURSION Returns maximum ML, AP, and net excursion of the CoP.
%
% ARGUMENTS
% ml - ML COP coordinates
% ap - AP COP coordinates
% fs - sampling frequency (Hz)
%
% ========================================================================%

% Number of frames for 25 ms
nframes = .025 * fs;

% Average the first 25 ms of data
ml_start = mean(ml(1:nframes));
ap_start = mean(ap(1:nframes));

% Maximum AP excursion
max_ap = max(ap(nframes:end)-ap_start);

% Maximum ML excursion
max_ml = max(ml(nframes:end)-ml_start);

% Distance from starting point.
max_net = max(sqrt((ap(nframes:end)-ap_start).^2 + ((ml(nframes:end)-ml_start).^2)));

end %end function
