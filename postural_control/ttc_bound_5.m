function [ mean_ttc, med_ttc, min_ttc ] = ttc_bound_5( ttc, n_mins, PLOT, labels )
%TTC_BOUND Calculates Mean, Medan, and Minimum TtC for each boundary.
%
% ARGUMENTS
% ttc - Time-to-Contact for each boundary. This argument can either be an m
% x 1 vector or an m x n matrix with TtC values for n boundaries where m is
% the number of data points in the time series. This function was designed
% to take the bound_ttc variable returned by the timetocontact function.
% 
% n_mins - Number of minima to include in the estimation of min_ttc. The
% default is 10% of the time series length.
%
% PLOT - boolean variable to request plots (0 = no plots, 1 = plots)
%
% labels - List of boundary labels for making plots.
%
% RETURNS
% mean_ttc - Vector containing the mean TtC for each boundary (excluding
% zeros). Returns n x 1 vector with one value per boundary.
%
% med_ttc - Vector containing the median TtC for each boundary (excluding
% zeros). Returns n x 1 vector with one value per boundary.
%
% min_ttc - Vector containing the minimum TtC for each boundary (excluding
% zeros). Returns n x 1 vector with one value per boundary. The minimum is
% determined by taking the mean of a user specified number (n_mins) of
% minima.
%
% ========================================================================%

%default plot setting, off if not provided
if nargin == 2
    PLOT = 0;
end

[m, n] = size(ttc); %length of TtC time series

%default number of minima is 10% of the time series length
if nargin == 1
    n_mins = round(0.1 * m);
    PLOT = 0;
end

%create mean TtC vector
mean_ttc = zeros(n,1);

%create median TtC vector
med_ttc = zeros(n,1);

%create minimum TtC vector
min_ttc = zeros(n,1);

%for each boundary
for i = 1:n

    mean_ttc(i,1) = nanmean(ttc(:,i)); %mean TtC for boundary i
    med_ttc(i,1) = nanmedian(ttc(ttc(:,i) > 0,i)); %median TtC for boundary i
    
    sort_ttc = sort(ttc(:,i)); %sort TtC (NaNs will be placed at end)
    min_ttc(i,1) = mean(sort_ttc(1:n_mins)); %minimum TtC
    
end % end boundary

%Make Plots ==============================================================%

if PLOT
    
    %Mean TtC Bar Graph
    figure('Color', 'white');
    title('Mean TtC');
    bar(mean_ttc,'FaceColor',[.5 .5 .5],'EdgeColor',[0 0 0], 'LineWidth', 1.0);
    set(gca,'XTick', [1:5]', 'XTickLabel', labels, 'TickLength', [0 0], 'FontName', 'Times', 'FontSize', 12);
    ylabel('Mean TtC(s)', 'FontSize', 15, 'FontName', 'Times');
    
    %Median TtC Bar Graph
    figure('Color', 'white');
    title('Median TtC');
    bar(med_ttc,'FaceColor',[.5 .5 .5],'EdgeColor',[0 0 0], 'LineWidth', 1.0);
    set(gca,'XTick', [1:5]', 'XTickLabel', labels, 'TickLength', [0 0], 'FontName', 'Times', 'FontSize', 12);
    ylabel('Median TtC(s)', 'FontSize', 15, 'FontName', 'Times');
    
    %Minimum TtC Bar Graph
    figure('Color', 'white');
    title('Minimum TtC');
    bar(min_ttc,'FaceColor',[.5 .5 .5],'EdgeColor',[0 0 0], 'LineWidth', 1.0);
    set(gca,'XTick', [1:5]', 'XTickLabel', labels, 'TickLength', [0 0], 'FontName', 'Times', 'FontSize', 12);
    ylabel('Minimum TtC(s)', 'FontSize', 15, 'FontName', 'Times');
    
end

end %end function