%This code will extract the 5 needed varaibles from the datasheets
%
% bound_pts = x and y bounday coordinates of specified shape
% fx - ML ground reaction force (N)
% fy - AP ground reaction force (N)
% fz - Vertical ground reaction force (N)
% mx - moment about x-axis (Nmm)
% my - moment about y-axis (Nmm)
% dz - vertical distance between surface and force plate origin (mm)
% fp_pts = coordinates of force plate corner locations
% time = trial time
% 

clc;
clear;

i = 0;

%Matrix of all participant IDs
%subID = [13; 25; 36; 70; 75; 86];
subID = [36];
data (1,:) = subID.';
%Z direction offset
dz=0;

%stance = file number for particlar stance
%1 = pre fatigue side by side
%2 = pre fatigue semi tandem
%3 = pre fatigue full tandem
%4 = pre fatigue single leg
%5 = post fatigue side by side
%6 = post fatigue semi tandem
%7 = post fatigue full tandem
%8 = post fatigue single leg 
stance = 1;

for i = 1
    
    n = subID(i,1);
    filepath = ['/Users/rossbrancati/Desktop/post_control_data/P',num2str(n),'/UFO_p',num2str(n),'_SPPB_000',num2str(stance),'.mat'];
    file_struct = load(filepath);
    fn(i,1) = fieldnames(file_struct);
    current_data_struct = file_struct.(fn{i});
    
    fx = current_data_struct.Force(2).Force(1,:);
    fy = current_data_struct.Force(2).Force(2,:);
    fz = current_data_struct.Force(2).Force(3,:);
    mx = current_data_struct.Force(2).Moment(1,:);
    my = current_data_struct.Force(2).Moment(2,:);
    
    %butterworth filter (8th order, 20Hz cutoff, lowpass)
    %[b,a] = butter(8,.2,'low');
    %fx = filter(b,a,fx);
    %fy = filter(b,a,fy);
    %fz = filter(b,a,fz);
    %mx = filter(b,a,mx);
    %my = filter(b,a,my);
    
    [ cop_x, cop_y ] = cop( fx, fy, fz, mx, my, dz );
    
    %Downsample the data
    cop_x = downsample(cop_x,16);
    cop_y = downsample(cop_y,16);
    
    %Sampling rate of force plates
    fs=100;

    %Excusrions of the COP
    [max_exc_ap, max_exc_ml, max_exc_net] = copMaxExcursion(cop_x, cop_y, fs);

    %Max velocities of COP
    [max_vel_ap, max_vel_ml, max_vel_net] = copMaxVelocity(cop_x, cop_y, fs );

    %Acceleration of COP
    [netA] = copAccel(cop_x, cop_y, fs);

    %COP path length.
    [path] = copPath(cop_x, cop_y);

    %RANGE COP Returns range in ML and AP directions separately
    [mlR, apR] = copRange(cop_x, cop_y);

    %Standard Deviation
    [sd_ml, sd_ap] = copSD(cop_x, cop_y);

    %COPVELOCITY Returns mean absolute ML, AP, and net speed of the COP
    samp = 1600;
    [ml_v, ap_v, net_v] = copVelocity(cop_x, cop_y, samp);

    %95% confidence interval ellipse of the COP
   [area,axes,angles,ellip] = ellipse(cop_x, cop_y,'show',0.95);
    
   data(2:17,i) = [max_exc_ap; max_exc_ml; max_exc_net; max_vel_ap; max_vel_ml; max_vel_net; netA; path; mlR; apR; sd_ml; sd_ap; ml_v; ap_v; net_v; area];
    
end

mean_data = mean(data,2).';

data_transpose = data.';

