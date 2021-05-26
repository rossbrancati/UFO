%clear; clc;

%load center-of-pressure and boundary data
load('example_cop.mat');

%CONTENTS OF .MAT FILE ===================================================%
% 30 s of quiet standing collected @ 120 Hz with AMTI OR6-7 Force Platform
% providing the three components of the ground reaction force (Fx, Fy, &
% Fz) and net moment (Mx, My, & Mz).
%
% Center-of-pressure was calculated after filtering the raw forces and
% moments using an 8th order Butterworth, low-pass filter with a cutoff
% frequency of 20 Hz. The force plate dimensions are 464 mm (width) x 508
% mm (length). The force plate origin is located at the bottom right hand
% corner with positive x and y axes extending to the right and forward,
% respectively. Thus, all CoP coordinates are positive and bounded on the
% intervals [0,464] and [0,508] in the ML and AP directions, respectively. 
% 
% For this example the anatomical landmarks selected to define the
% base-of-support were the 2nd phalanx of the Hallux, 5th metatarsal, and
% the most dorsal point of the calcaneus for each foot.
%
% Variables
%   cop_x - center-of-pressure coordinate in the ML direction
%   cop_y - center-of-pressure coordinate in the Ap direction
%   time - time series with dt = 1/samp_rate = 1/120
%   bound_pts - coordinates for the landmarks selected to define the 
%               boundaries of the base-of-support (column 1 = x coordinate,
%               column 2 = y coordinate). The landmarks are in the following
%               order: right toe, right m5, right heel, left heel, left m5,
%               and left toe. ** BOUNDARY LANDMARKS MUST BE ORGANIZED IN
%               CLOCKWISE FASHION, BUT MAY START WITH ANY LANDMARK.
%   fp_pts - coordinates of the corners of the force platform starting with
%            at the top right and moving clockwise (column 1 = x coordinate,
%            column 2 = y coordinate).
% ========================================================================%

%produce plots of the center-ofpressure ==================================%
figure('Color', 'white');
subplot(2,1,1);
plot(time, cop_x, 'k'); %plot ML CoP
xlabel('Time (s)');
ylabel('ML Position (mm)');

subplot(2,1,2);
plot(time, cop_y, 'k'); %plot AP CoP
xlabel('Time (s)');
ylabel('AP Position (mm)');
title('Figure 1');

x_fp = [fp_pts(:,1); fp_pts(1,1)]; %x coordinates to produce force plate outline
y_fp = [fp_pts(:,2); fp_pts(1,2)]; %y coordinates to produce force plate outline

x_bos = [bound_pts(:,1); bound_pts(1,1)]; %x coordinates to produce base-of-support outline
y_bos = [bound_pts(:,2); bound_pts(1,2)]; %y cooridnates to produce base-of-support outline 

figure('Color', 'white');
plot(cop_x, cop_y, 'k'); %plot CoPx versus CoPy
hold on;
plot(x_fp, y_fp, 'k'); %plot force plate outline
scatter(fp_pts(:,1), fp_pts(:,2), 'k', 'filled'); %plot force plate corners
plot(x_bos, y_bos, 'k'); %plot base-of-support outline
scatter(bound_pts(:,1), bound_pts(:,2), 'k', 'filled'); %plot base-of-support corners
hold off;
xlabel('ML Position (mm)');
ylabel('AP Position (mm)');
%axis([(fp_pts(2,1) - 32) (fp_pts(3,1) + 32) (fp_pts(3,2) - 10) (fp_pts(1,2) + 10)]); %square axes
axis([(fp_pts(3,1) - 32) (fp_pts(2,1) + 32) (fp_pts(3,2) - 10) (fp_pts(1,2) + 10)]); %square axes
title('Figure 2');

%Calculate Time-to-Contact ===============================================%

bound_labels = {'F','FR','BR','B','BL','FL'}; %labels for boundaries

samp_rate = 1600; %sampling rate in Hz

method = 1; %1 = Riccio, 2 = Slobounov, 3 = Jerk 

%compute TtC
[ttc, bound_ttc, bound_perc] = timetocontact(cop_x, cop_y, 1/samp_rate, bound_pts, method, bound_labels );

%plot subset of virtual trajectories to check that method is working
ttc_trajectplot(cop_x, cop_y, 1/samp_rate, x_bos, y_bos, ttc, method);

%Plot TtC within base of support
figure('color', 'white');
plot3(cop_x,cop_y,ttc,'k');
grid on;
hold on;
plot3(x_bos, y_bos, zeros(length(x_bos),1),'k');
scatter3(x_bos,y_bos,zeros(length(x_bos),1), 'k','filled');
plot3(x_fp, y_fp, zeros(length(x_fp),1),'k');
scatter3(x_fp,y_fp,zeros(length(x_fp),1), 'k','filled');
set(gca, 'ZTickLabel', num2str(get(gca,'ZTick')','%.1f'));
xlabel('ML CoP (mm)');
ylabel('AP CoP (mm)');
zlabel('Time-to-Contact (s)');
axis([(fp_pts(3,1) - 32) (fp_pts(1,1) + 32) (fp_pts(3,2) - 10) (fp_pts(1,2) + 10)]); %square axes
title('Figure 3');

%Plot TtC time series
figure('color','white');
plot(time, ttc, 'k');
xlabel('Time (s)');
ylabel('Time-To-Contact (s)');
title('Figure 4');

%Plot TtC histogram with log normal fit
fitparm = lognfit(ttc);
logpdf = lognpdf([0:.01:max(ttc)]',fitparm(1),fitparm(2));

figure('color','white');
histogram(ttc,'Normalization','pdf','FaceColor',[50/255 50/255 50/255],'EdgeColor',[0/255 0/255 0/255]);
hold on;
plot([0:.01:max(ttc)]',logpdf,'r');
xlabel('Time-to-Contact (s)');
ylabel('Probability Density');
title('Figure 5');

%Compute TtC to each boundary
[ mean_ttc, med_ttc, min_ttc ] = ttc_bound( bound_ttc, 50, method, bound_labels );



