%%SIDE BY SIDE STANCE
%For other stances, base of support shapes are different so the bound_pts
%locations and their connections are different.

clear
clc

%Ttc example - Pre_Fatigue for side-by-side stance.
%
%Variables
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
%
%Load in data - Change subject folder, subject ID, and trial
filepath = ['/Users/rossbrancati/Desktop/post_control_data/P86/UFO_p86_SPPB_0001.mat'];
load(filepath);

%change the mat_file name for each subjects mat file
mat_file = UFO_p86_SPPB_0002;

%cop_x and cop_y calculations > if you are not going to use the COP from
%QTM
%fx = mat_file.Force(2).Force(2,:);
%fy = mat_file.Force(2).Force(1,:);
%fz = mat_file.Force(2).Force(3,:);
%mx = mat_file.Force(2).Moment(1,:);
%my = mat_file.Force(2).Moment(2,:);

%dz=3.7;
%[cop_x,cop_y] = cop(fx, fy, fz, mx, my, dz);
raw_COP_x = mat_file.Force(2).COP(2,:);
raw_COP_y = mat_file.Force(2).COP(1,:);
offset_x = 310.85594;
offset_y = 1010.0105;

cop_x = offset_x + raw_COP_x.';
%COP in y direction must be multiplied by -1 because of the orientation of
%the coordinate system of the force plate. See AMTI manual for more details
cop_y = offset_y + raw_COP_y.'*-1;

%Downsample the data
cop_x = downsample(cop_x,16);
cop_y = downsample(cop_y,16);

%2nd order filter with cutoff at 10 Hz
[b,a] = butter(2,.1);
cop_x = filter(b,a,cop_x);
cop_y = filter(b,a,cop_y);

cop_x = cop_x(10:end,1);
cop_y = cop_y(10:end,1);

%marker locations
r2ndmet = [(mean(mat_file.Trajectories.Labeled.Data(2,2,:))), mean(mat_file.Trajectories.Labeled.Data(2,1,:))+60];
r5thmet = [mean(mat_file.Trajectories.Labeled.Data(3,2,:)), mean(mat_file.Trajectories.Labeled.Data(3,1,:))];
rlatheel = [mean(mat_file.Trajectories.Labeled.Data(5,2,:)), mean(mat_file.Trajectories.Labeled.Data(5,1,:))];
rheel = [mean(mat_file.Trajectories.Labeled.Data(4,2,:)), mean(mat_file.Trajectories.Labeled.Data(4,1,:))];
lheel = [mean(mat_file.Trajectories.Labeled.Data(9,2,:)), mean(mat_file.Trajectories.Labeled.Data(9,1,:))];
llatheel = [mean(mat_file.Trajectories.Labeled.Data(10,2,:)), mean(mat_file.Trajectories.Labeled.Data(10,1,:))];
l5thmet = [mean(mat_file.Trajectories.Labeled.Data(8,2,:)), mean(mat_file.Trajectories.Labeled.Data(8,1,:))];
l2ndmet = [(mean(mat_file.Trajectories.Labeled.Data(7,2,:))), mean(mat_file.Trajectories.Labeled.Data(7,1,:))+60];

bound_pts = [r2ndmet; r5thmet; rlatheel; rheel; lheel; llatheel; l5thmet; l2ndmet];

%Force plate corner locations
topL = [12.9277,1303.3];
bottomL = [7.2091,710.5410];
bottomR = [597.9800,709.6610];
topR = [603.9260,1300.6];
fp_pts = [topR; bottomR; bottomL; topL];

%time vector
time = linspace(0.0001,30,length(cop_x)); 
time = time.';
%=========================================================================%

%Time to contact calculations and plots:

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
set(gca, 'XDir','reverse');
hold on;
plot(cop_x, cop_y, 'k'); %plot CoPx versus CoPy
plot(x_fp, y_fp, 'k'); %plot force plate outline
plot(310,1010,'r*');
scatter(fp_pts(:,1), fp_pts(:,2), 'k', 'filled'); %plot force plate corners
plot(x_bos, y_bos, 'k'); %plot base-of-support outline
scatter(bound_pts(:,1), bound_pts(:,2), 'k', 'filled'); %plot base-of-support corners
hold off;
xlabel('ML Position (mm)');
ylabel('AP Position (mm)');
xlim([(fp_pts(3,1) - 32) (fp_pts(1,1) + 32)]); 
ylim([(fp_pts(3,2) - 10) (fp_pts(1,2) + 10)]);
%old axes
%xlim([(fp_pts(1,1) - 32) (fp_pts(3,1) + 32)]); 
%ylim([(fp_pts(3,2) - 10) (fp_pts(1,2) + 10)]); %square axes
title('Figure 2');

%Calculate Time-to-Contact ===============================================%
%Boundary labels
bound_labels = {'FR','R','BR','B','BL','L','FL','F'};

%make sure you adjust sampling rate if you downsample the raw data
samp_rate = 100; %sampling rate in Hz

method = 2; %1 = Riccio, 2 = Slobounov, 3 = Jerk 

%compute TtC
[ttc, bound_ttc, bound_perc] = timetocontact(cop_x, cop_y, 1/samp_rate, bound_pts, method, bound_labels );

%plot subset of virtual trajectories to check that method is working
ttc_trajectplot(cop_x, cop_y, 1/samp_rate, x_bos, y_bos, ttc, method);
set(gca, 'XDir','reverse'); %reverses x axis due to force plate and GCS orientations
xlim([(fp_pts(3,1) - 32) (fp_pts(1,1) + 32)]); 
ylim([(fp_pts(3,2) - 10) (fp_pts(1,2) + 10)]);
%title('Time to Contact with Boundaries')
xlim([150,400]);
ylim([850, 1150]);


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
xlim([(fp_pts(3,1) - 32) (fp_pts(1,1) + 32)]); 
ylim([(fp_pts(3,2) - 10) (fp_pts(1,2) + 10)]);
%axis([(fp_pts(1,1) + 32) (fp_pts(3,1) - 32) (fp_pts(3,2) - 10) (fp_pts(1,2) + 10)]);
%axis([(fp_pts(3,1) - 32) (fp_pts(1,1) + 32) (fp_pts(3,2) - 10) (fp_pts(1,2) + 10)]); %square axes
title('3D Time to Contact Plot');

%Plot TtC time series
figure('color','white');
plot(time, ttc, 'k');
xlabel('Time (s)');
ylabel('Time-To-Contact (s)');
title('Time to Contact - 30 Second Trial');

%Plot TtC histogram with log normal fit
fitparm = lognfit(ttc);
logpdf = lognpdf([0:.01:max(ttc)]',fitparm(1),fitparm(2));
figure('color','white');
histogram(ttc,'Normalization','pdf','FaceColor',[50/255 50/255 50/255],'EdgeColor',[0/255 0/255 0/255]);
hold on;
plot([0:.01:max(ttc)]',logpdf,'r');
xlabel('Time-to-Contact (s)');
ylabel('Probability Density');
title('TTC Histogram with Log Normal Fit');

%Compute TtC to each boundary
%Make sure the number of boundary labels (N) is correct in the function ttc_bound_N
[ mean_ttc, med_ttc, min_ttc ] = ttc_bound_8( bound_ttc, 50, method, bound_labels);

min_ttc = min_ttc.';
mean_ttc = mean_ttc.';