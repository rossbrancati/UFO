function [ perc ] = ttc_bound_perc( counts, n_bounds )
%TTC_BOUND_PERC Calculates the percentage of virtual contacts attributed to
%each boundary.
%
% ARGUMENTS
% counts - vector of crossed boundaries for each instant in time
% n_bounds - number of boundaries
%
% RETURNS
% perc - Vector of size n_bounds x 1 containing the percentage of contacts
% to each boundary.
%
%=========================================================================%

%number of data points
n = length(counts);

%percentage array
perc = zeros(n_bounds,1);

%for each boundary
for i = 1:n_bounds
    
    perc(i,1) = (sum(counts == i) / n) * 100;
    
end %end boundary

end %end function