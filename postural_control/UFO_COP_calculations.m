clc;
clear;

i = 0;

%Matrix of all participant IDs
subID = [13; 25; 36; 70; 75; 86];
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
stance = 8;

for i = 1:6
    
    n = subID(i,1);
    filepath = ['/Users/rossbrancati/Desktop/post_control_data/P',num2str(n),'/UFO_p',num2str(n),'_SPPB_000',num2str(stance),'.mat'];
    file_struct = load(filepath);
    fn(i,1) = fieldnames(file_struct);
    current_data_struct = file_struct.(fn{i});
    
    raw_COP_x = current_data_struct.Force(2).COP(2,:);
    raw_COP_y = current_data_struct.Force(2).COP(1,:);

    cop_x = raw_COP_x.';
    cop_y = raw_COP_y.'*-1;
    
    %Downsample the data
    cop_x = downsample(cop_x,16);
    cop_y = downsample(cop_y,16);
    
    %[b,a] = butter(8,.2,'low');
    %cop_x = filter(b,a,cop_x);
    %cop_y = filter(b,a,cop_y);
    
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

