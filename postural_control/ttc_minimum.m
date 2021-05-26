function [ min_ttc ] = ttc_minimum( ttc, n_mins )
%Estimates the minimum TtC as the average of the n_mins lowest values in
%the TtC time series.

sort_ttc = sort(ttc);
min_ttc = mean(sort_ttc(1:n_mins));

end