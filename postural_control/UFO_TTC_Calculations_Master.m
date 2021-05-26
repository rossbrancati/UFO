%%%Time to contact calculations%%%
clear;
clc;

folder_path = '/Users/rossbrancati/Desktop/post_control_data/time_to_contact';

subID = [13;65;86];
[rows,cols] = size(subID);
subject=0;
trial=0;
ttc_master = zeros(8,4);
ttc_master_all = [];


for subject = 1:3
    
    s = subID(subject,1);
    subject_folder = [folder_path,'/P',num2str(s)];
    
    for trial = 1:8
        
        file_path = [subject_folder,'/UFO_p',num2str(s),'_SPPB_000',num2str(trial)];
        mat_file = struct2cell(load(file_path));
        mat_file = mat_file{1, 1};
        
        if trial == 1
        
            %Reading in COP data
            raw_COP_x = mat_file.Force(2).COP(2,:);
            raw_COP_y = mat_file.Force(2).COP(1,:);
            offset_x = 310.85594;
            offset_y = 1010.0105;

            %Offset COP
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

            %skip first 10 frames of trial
            cop_x = cop_x(25:end-25,1);
            cop_y = cop_y(25:end-25,1);

            %marker locations
            r2ndmet = [(mean(mat_file.Trajectories.Labeled.Data(1,2,:))), mean(mat_file.Trajectories.Labeled.Data(1,1,:))+60];
            r5thmet = [mean(mat_file.Trajectories.Labeled.Data(2,2,:)), mean(mat_file.Trajectories.Labeled.Data(2,1,:))];
            rlatheel = [mean(mat_file.Trajectories.Labeled.Data(4,2,:)), mean(mat_file.Trajectories.Labeled.Data(4,1,:))];
            rheel = [mean(mat_file.Trajectories.Labeled.Data(3,2,:)), mean(mat_file.Trajectories.Labeled.Data(3,1,:))];
            lheel = [mean(mat_file.Trajectories.Labeled.Data(7,2,:)), mean(mat_file.Trajectories.Labeled.Data(7,1,:))];
            llatheel = [mean(mat_file.Trajectories.Labeled.Data(8,2,:)), mean(mat_file.Trajectories.Labeled.Data(8,1,:))];
            l5thmet = [mean(mat_file.Trajectories.Labeled.Data(6,2,:)), mean(mat_file.Trajectories.Labeled.Data(6,1,:))];
            l2ndmet = [(mean(mat_file.Trajectories.Labeled.Data(5,2,:))), mean(mat_file.Trajectories.Labeled.Data(5,1,:))+60];

            %vector of bounds points
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
            
            x_bos = [bound_pts(:,1); bound_pts(1,1)]; %x coordinates to produce base-of-support outline
            y_bos = [bound_pts(:,2); bound_pts(1,2)]; %y cooridnates to produce base-of-support outline 
            
            %COP vs time
            figure(subject);
            subplot(8,3,1);
            plot(time, cop_x, 'k'); %plot ML CoP
            xlabel('Time (s)');
            ylabel('ML Position (mm)');
            subplot(8,3,2);
            plot(time, cop_y, 'k'); %plot AP CoP
            xlabel('Time (s)');
            ylabel('AP Position (mm)')

            %Calculate Time-to-Contact ===============================================%
            %Boundary labels
            bound_labels = {'FR','R','BR','B','BL','L','FL','F'};

            %make sure you adjust sampling rate if you downsample the raw data
            samp_rate = 100; %sampling rate in Hz

            %method for calculating TTC
            method = 2; %1 = Riccio, 2 = Slobounov, 3 = Jerk 

            %compute TtC
            [ttc, bound_ttc, bound_perc] = timetocontact(cop_x, cop_y, 1/samp_rate, bound_pts, method, bound_labels);

            %plot subset of virtual trajectories to check that method is working
            subplot(8,3,3);
            ttc_trajectplot(cop_x, cop_y, 1/samp_rate, x_bos, y_bos, ttc, method);
            set(gca, 'XDir','reverse'); %reverses x axis due to force plate and GCS orientations
            xlim([(fp_pts(3,1) - 32) (fp_pts(1,1) + 32)]); 
            ylim([(fp_pts(3,2) - 10) (fp_pts(1,2) + 10)]);

            %Compute TtC to each boundary
            %Make sure the number of boundary labels (N) is correct in the function ttc_bound_N
            [mean_ttc, med_ttc, min_ttc] = ttc_bound_8(bound_ttc, 50, method, bound_labels);

            ttc_master(trial,1) = mean(mean_ttc);
            ttc_master(trial,2) = std(mean_ttc);
            ttc_master(trial,3) = min(min_ttc);
            ttc_master(trial,4) = std(min_ttc);

            
        else if trial == 2
                
                %Reading in COP data
            raw_COP_x = mat_file.Force(2).COP(2,:);
            raw_COP_y = mat_file.Force(2).COP(1,:);
            offset_x = 310.85594;
            offset_y = 1010.0105;

            %Offset COP
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

            %skip first 10 frames of trial
            cop_x = cop_x(25:end-25,1);
            cop_y = cop_y(25:end-25,1);
           
            check_stance = isstrprop(mat_file.Trajectories.Labeled.Labels{1, 3},'alpha');
            
            if sum(check_stance) == 5
            
                %marker locations
                r2ndmet = [(mean(mat_file.Trajectories.Labeled.Data(1,2,:))), mean(mat_file.Trajectories.Labeled.Data(1,1,:))+60];
                r5thmet = [mean(mat_file.Trajectories.Labeled.Data(2,2,:)), mean(mat_file.Trajectories.Labeled.Data(2,1,:))];
                rheel = [mean(mat_file.Trajectories.Labeled.Data(3,2,:)), mean(mat_file.Trajectories.Labeled.Data(3,1,:))];
                llatheel = [mean(mat_file.Trajectories.Labeled.Data(6,2,:)), mean(mat_file.Trajectories.Labeled.Data(6,1,:))];
                l5thmet = [mean(mat_file.Trajectories.Labeled.Data(5,2,:)), mean(mat_file.Trajectories.Labeled.Data(5,1,:))];
                l2ndmet = [(mean(mat_file.Trajectories.Labeled.Data(4,2,:))), mean(mat_file.Trajectories.Labeled.Data(4,1,:))+60];

                %vector of bounds points
                %6 markers
                bound_pts = [l2ndmet; r2ndmet; r5thmet; rheel; llatheel; l5thmet];
            
            else
               
                %marker locations
                r2ndmet = [(mean(mat_file.Trajectories.Labeled.Data(1,2,:))), mean(mat_file.Trajectories.Labeled.Data(1,1,:))+60];
                r5thmet = [mean(mat_file.Trajectories.Labeled.Data(2,2,:)), mean(mat_file.Trajectories.Labeled.Data(2,1,:))];
                rlatheel = [mean(mat_file.Trajectories.Labeled.Data(3,2,:)), mean(mat_file.Trajectories.Labeled.Data(3,1,:))];
                lheel = [mean(mat_file.Trajectories.Labeled.Data(6,2,:)), mean(mat_file.Trajectories.Labeled.Data(6,1,:))];
                l5thmet = [mean(mat_file.Trajectories.Labeled.Data(5,2,:)), mean(mat_file.Trajectories.Labeled.Data(5,1,:))];
                l2ndmet = [(mean(mat_file.Trajectories.Labeled.Data(4,2,:))), mean(mat_file.Trajectories.Labeled.Data(4,1,:))+60];

                %vector of bounds points
                %6 Markers
                bound_pts = [r2ndmet; r5thmet; rlatheel; lheel; l5thmet; l2ndmet];
            end
                
            %Force plate corner locations
            topL = [12.9277,1303.3];
            bottomL = [7.2091,710.5410];
            bottomR = [597.9800,709.6610];
            topR = [603.9260,1300.6];
            fp_pts = [topR; bottomR; bottomL; topL];

            %time vector
            time = linspace(0.0001,30,length(cop_x)); 
            time = time.';

            x_bos = [bound_pts(:,1); bound_pts(1,1)]; %x coordinates to produce base-of-support outline
            y_bos = [bound_pts(:,2); bound_pts(1,2)]; %y cooridnates to produce base-of-support outline 
            
            %COP vs time
            figure(subject);
            subplot(8,3,4);
            plot(time, cop_x, 'k'); %plot ML CoP
            xlabel('Time (s)');
            ylabel('ML Position (mm)');
            subplot(8,3,5);
            plot(time, cop_y, 'k'); %plot AP CoP
            xlabel('Time (s)');
            ylabel('AP Position (mm)')

            %Calculate Time-to-Contact ===============================================%
            %Boundary labels
            bound_labels = {'FR','R','BR','BL','L','FL'};

            %make sure you adjust sampling rate if you downsample the raw data
            samp_rate = 100; %sampling rate in Hz

            %method for calculating TTC
            method = 2; %1 = Riccio, 2 = Slobounov, 3 = Jerk 

            %compute TtC
            [ttc, bound_ttc, bound_perc] = timetocontact(cop_x, cop_y, 1/samp_rate, bound_pts, method, bound_labels);

            %plot subset of virtual trajectories to check that method is working
            subplot(8,3,6);
            ttc_trajectplot(cop_x, cop_y, 1/samp_rate, x_bos, y_bos, ttc, method);
            set(gca, 'XDir','reverse'); %reverses x axis due to force plate and GCS orientations
            xlim([(fp_pts(3,1) - 32) (fp_pts(1,1) + 32)]); 
            ylim([(fp_pts(3,2) - 10) (fp_pts(1,2) + 10)]);

            %Compute TtC to each boundary
            %Make sure the number of boundary labels (N) is correct in the function ttc_bound_N
            [mean_ttc, med_ttc, min_ttc] = ttc_bound_6(bound_ttc, 50, method, bound_labels);

            ttc_master(trial,1) = mean(mean_ttc);
            ttc_master(trial,2) = std(mean_ttc);
            ttc_master(trial,3) = min(min_ttc);
            ttc_master(trial,4) = std(min_ttc);
        
            
        else if trial == 3
        
            %Reading in COP data
            raw_COP_x = mat_file.Force(2).COP(2,:);
            raw_COP_y = mat_file.Force(2).COP(1,:);
            offset_x = 310.85594;
            offset_y = 1010.0105;

            %Offset COP
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

            %skip first 10 frames of trial
            cop_x = cop_x(25:end-25,1);
            cop_y = cop_y(25:end-25,1);
           
            check_stance = isstrprop(mat_file.Trajectories.Labeled.Labels{1, 2},'alpha');
            
            if sum(check_stance) == 8
                %marker locations
                l1stmet = [(mean(mat_file.Trajectories.Labeled.Data(3,2,:))), mean(mat_file.Trajectories.Labeled.Data(3,1,:))];
                rlatheel = [mean(mat_file.Trajectories.Labeled.Data(1,2,:)), mean(mat_file.Trajectories.Labeled.Data(1,1,:))];
                rmedheel = [mean(mat_file.Trajectories.Labeled.Data(2,2,:)), mean(mat_file.Trajectories.Labeled.Data(2,1,:))];
                l5thmet = [mean(mat_file.Trajectories.Labeled.Data(4,2,:)), mean(mat_file.Trajectories.Labeled.Data(4,1,:))];

                %vector of bounds points
                %4 markers - left leg forward
                bound_pts = [l1stmet; rlatheel; rmedheel; l5thmet];
            
            else
                %marker locations
                r1stmet = [(mean(mat_file.Trajectories.Labeled.Data(1,2,:))), mean(mat_file.Trajectories.Labeled.Data(1,1,:))];
                r5thmet = [mean(mat_file.Trajectories.Labeled.Data(2,2,:)), mean(mat_file.Trajectories.Labeled.Data(2,1,:))];
                llatheel = [mean(mat_file.Trajectories.Labeled.Data(4,2,:)), mean(mat_file.Trajectories.Labeled.Data(4,1,:))];
                lmedheel = [mean(mat_file.Trajectories.Labeled.Data(3,2,:)), mean(mat_file.Trajectories.Labeled.Data(3,1,:))];

                %vector of bounds points
                %4 markers
                bound_pts = [r5thmet; lmedheel; llatheel; r1stmet];
            end
                
            %Force plate corner locations
            topL = [12.9277,1303.3];
            bottomL = [7.2091,710.5410];
            bottomR = [597.9800,709.6610];
            topR = [603.9260,1300.6];
            fp_pts = [topR; bottomR; bottomL; topL];

            %time vector
            time = linspace(0.0001,30,length(cop_x)); 
            time = time.';
            
            x_bos = [bound_pts(:,1); bound_pts(1,1)]; %x coordinates to produce base-of-support outline
            y_bos = [bound_pts(:,2); bound_pts(1,2)]; %y cooridnates to produce base-of-support outline 
            
            %COP vs time
            figure(subject);
            subplot(8,3,7);
            plot(time, cop_x, 'k'); %plot ML CoP
            xlabel('Time (s)');
            ylabel('ML Position (mm)');
            subplot(8,3,8);
            plot(time, cop_y, 'k'); %plot AP CoP
            xlabel('Time (s)');
            ylabel('AP Position (mm)')

            %Calculate Time-to-Contact ===============================================%
            %Boundary labels
            bound_labels = {'R','B','L','F'};

            %make sure you adjust sampling rate if you downsample the raw data
            samp_rate = 100; %sampling rate in Hz

            %method for calculating TTC
            method = 2; %1 = Riccio, 2 = Slobounov, 3 = Jerk 

            %compute TtC
            [ttc, bound_ttc, bound_perc] = timetocontact(cop_x, cop_y, 1/samp_rate, bound_pts, method, bound_labels);

            %plot subset of virtual trajectories to check that method is working
            subplot(8,3,9);
            ttc_trajectplot(cop_x, cop_y, 1/samp_rate, x_bos, y_bos, ttc, method);
            set(gca, 'XDir','reverse'); %reverses x axis due to force plate and GCS orientations
            xlim([(fp_pts(3,1) - 32) (fp_pts(1,1) + 32)]); 
            ylim([(fp_pts(3,2) - 10) (fp_pts(1,2) + 10)]);

            %Compute TtC to each boundary
            %Make sure the number of boundary labels (N) is correct in the function ttc_bound_N
            [mean_ttc, med_ttc, min_ttc] = ttc_bound_4(bound_ttc, 50, method, bound_labels);

            ttc_master(trial,1) = mean(mean_ttc);
            ttc_master(trial,2) = std(mean_ttc);
            ttc_master(trial,3) = min(min_ttc);
            ttc_master(trial,4) = std(min_ttc);
            
        else if trial == 4
                
            %Reading in COP data
            raw_COP_x = mat_file.Force(2).COP(2,:);
            raw_COP_y = mat_file.Force(2).COP(1,:);
            offset_x = 310.85594;
            offset_y = 1010.0105;

            %Offset COP
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

            %skip first 10 frames of trial
            cop_x = cop_x(25:end-25,1);
            cop_y = cop_y(25:end-25,1);
           
            
            check_stance = mat_file.Trajectories.Labeled.Data(3,2,1) - mat_file.Trajectories.Labeled.Data(1,2,1);
            
            if check_stance > 0
                %marker locations
                firstmet = [(mean(mat_file.Trajectories.Labeled.Data(1,2,:))), mean(mat_file.Trajectories.Labeled.Data(1,1,:))];
                secondmet = [(mean(mat_file.Trajectories.Labeled.Data(2,2,:))), mean(mat_file.Trajectories.Labeled.Data(2,1,:))+60];
                fifthmet = [mean(mat_file.Trajectories.Labeled.Data(3,2,:)), mean(mat_file.Trajectories.Labeled.Data(3,1,:))];
                latheel = [mean(mat_file.Trajectories.Labeled.Data(6,2,:)), mean(mat_file.Trajectories.Labeled.Data(6,1,:))];
                heel = [mean(mat_file.Trajectories.Labeled.Data(4,2,:)), mean(mat_file.Trajectories.Labeled.Data(4,1,:))];
                medheel = [mean(mat_file.Trajectories.Labeled.Data(5,2,:)), mean(mat_file.Trajectories.Labeled.Data(5,1,:))];

                %Left Leg bounds_pts
                bound_pts = [firstmet; medheel; heel; latheel; fifthmet; secondmet];

            else
                %marker locations
                firstmet = [(mean(mat_file.Trajectories.Labeled.Data(1,2,:))), mean(mat_file.Trajectories.Labeled.Data(1,1,:))];
                secondmet = [(mean(mat_file.Trajectories.Labeled.Data(2,2,:))), mean(mat_file.Trajectories.Labeled.Data(2,1,:))+60];
                fifthmet = [mean(mat_file.Trajectories.Labeled.Data(3,2,:)), mean(mat_file.Trajectories.Labeled.Data(3,1,:))];
                latheel = [mean(mat_file.Trajectories.Labeled.Data(5,2,:)), mean(mat_file.Trajectories.Labeled.Data(5,1,:))];
                heel = [mean(mat_file.Trajectories.Labeled.Data(4,2,:)), mean(mat_file.Trajectories.Labeled.Data(4,1,:))];
                medheel = [mean(mat_file.Trajectories.Labeled.Data(6,2,:)), mean(mat_file.Trajectories.Labeled.Data(6,1,:))];
                
                %Right Leg bounds_pts
                bound_pts = [fifthmet; latheel; heel; medheel; firstmet; secondmet];
            end
                
            %Force plate corner locations
            topL = [12.9277,1303.3];
            bottomL = [7.2091,710.5410];
            bottomR = [597.9800,709.6610];
            topR = [603.9260,1300.6];
            fp_pts = [topR; bottomR; bottomL; topL];

            %time vector
            time = linspace(0.0001,30,length(cop_x)); 
            time = time.';

            x_bos = [bound_pts(:,1); bound_pts(1,1)]; %x coordinates to produce base-of-support outline
            y_bos = [bound_pts(:,2); bound_pts(1,2)]; %y cooridnates to produce base-of-support outline 
            
            %COP vs time
            figure(subject);
            subplot(8,3,10);
            plot(time, cop_x, 'k'); %plot ML CoP
            xlabel('Time (s)');
            ylabel('ML Position (mm)');
            subplot(8,3,11);
            plot(time, cop_y, 'k'); %plot AP CoP
            xlabel('Time (s)');
            ylabel('AP Position (mm)')

            %Calculate Time-to-Contact ===============================================%
            %Boundary labels
            bound_labels = {'FR','R','BR','BL','L','FL'};

            %make sure you adjust sampling rate if you downsample the raw data
            samp_rate = 100; %sampling rate in Hz

            %method for calculating TTC
            method = 2; %1 = Riccio, 2 = Slobounov, 3 = Jerk 

            %compute TtC
            [ttc, bound_ttc, bound_perc] = timetocontact(cop_x, cop_y, 1/samp_rate, bound_pts, method, bound_labels);

            %plot subset of virtual trajectories to check that method is working
            subplot(8,3,12);
            ttc_trajectplot(cop_x, cop_y, 1/samp_rate, x_bos, y_bos, ttc, method);
            set(gca, 'XDir','reverse'); %reverses x axis due to force plate and GCS orientations
            xlim([(fp_pts(3,1) - 32) (fp_pts(1,1) + 32)]); 
            ylim([(fp_pts(3,2) - 10) (fp_pts(1,2) + 10)]);

            %Compute TtC to each boundary
            %Make sure the number of boundary labels (N) is correct in the function ttc_bound_N
            [mean_ttc, med_ttc, min_ttc] = ttc_bound_6(bound_ttc, 50, method, bound_labels);

            ttc_master(trial,1) = mean(mean_ttc);
            ttc_master(trial,2) = std(mean_ttc);
            ttc_master(trial,3) = min(min_ttc);
            ttc_master(trial,4) = std(min_ttc);
        
        else if trial == 5
        
            %Reading in COP data
            raw_COP_x = mat_file.Force(2).COP(2,:);
            raw_COP_y = mat_file.Force(2).COP(1,:);
            offset_x = 310.85594;
            offset_y = 1010.0105;

            %Offset COP
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

            %skip first 10 frames of trial
            cop_x = cop_x(25:end-25,1);
            cop_y = cop_y(25:end-25,1);

            %marker locations
            r2ndmet = [(mean(mat_file.Trajectories.Labeled.Data(1,2,:))), mean(mat_file.Trajectories.Labeled.Data(1,1,:))+60];
            r5thmet = [mean(mat_file.Trajectories.Labeled.Data(2,2,:)), mean(mat_file.Trajectories.Labeled.Data(2,1,:))];
            rlatheel = [mean(mat_file.Trajectories.Labeled.Data(4,2,:)), mean(mat_file.Trajectories.Labeled.Data(4,1,:))];
            rheel = [mean(mat_file.Trajectories.Labeled.Data(3,2,:)), mean(mat_file.Trajectories.Labeled.Data(3,1,:))];
            lheel = [mean(mat_file.Trajectories.Labeled.Data(7,2,:)), mean(mat_file.Trajectories.Labeled.Data(7,1,:))];
            llatheel = [mean(mat_file.Trajectories.Labeled.Data(8,2,:)), mean(mat_file.Trajectories.Labeled.Data(8,1,:))];
            l5thmet = [mean(mat_file.Trajectories.Labeled.Data(6,2,:)), mean(mat_file.Trajectories.Labeled.Data(6,1,:))];
            l2ndmet = [(mean(mat_file.Trajectories.Labeled.Data(5,2,:))), mean(mat_file.Trajectories.Labeled.Data(5,1,:))+60];

            %vector of bounds points
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

            x_bos = [bound_pts(:,1); bound_pts(1,1)]; %x coordinates to produce base-of-support outline
            y_bos = [bound_pts(:,2); bound_pts(1,2)]; %y cooridnates to produce base-of-support outline 
            
            %COP vs time
            figure(subject);
            subplot(8,3,13);
            plot(time, cop_x, 'k'); %plot ML CoP
            xlabel('Time (s)');
            ylabel('ML Position (mm)');
            subplot(8,3,14);
            plot(time, cop_y, 'k'); %plot AP CoP
            xlabel('Time (s)');
            ylabel('AP Position (mm)')

            %Calculate Time-to-Contact ===============================================%
            %Boundary labels
            bound_labels = {'FR','R','BR','B','BL','L','FL','F'};

            %make sure you adjust sampling rate if you downsample the raw data
            samp_rate = 100; %sampling rate in Hz

            %method for calculating TTC
            method = 2; %1 = Riccio, 2 = Slobounov, 3 = Jerk 

            %compute TtC
            [ttc, bound_ttc, bound_perc] = timetocontact(cop_x, cop_y, 1/samp_rate, bound_pts, method, bound_labels);

            %plot subset of virtual trajectories to check that method is working
            subplot(8,3,15);
            ttc_trajectplot(cop_x, cop_y, 1/samp_rate, x_bos, y_bos, ttc, method);
            set(gca, 'XDir','reverse'); %reverses x axis due to force plate and GCS orientations
            xlim([(fp_pts(3,1) - 32) (fp_pts(1,1) + 32)]); 
            ylim([(fp_pts(3,2) - 10) (fp_pts(1,2) + 10)]);

            %Compute TtC to each boundary
            %Make sure the number of boundary labels (N) is correct in the function ttc_bound_N
            [mean_ttc, med_ttc, min_ttc] = ttc_bound_8(bound_ttc, 50, method, bound_labels);

            ttc_master(trial,1) = mean(mean_ttc);
            ttc_master(trial,2) = std(mean_ttc);
            ttc_master(trial,3) = min(min_ttc);
            ttc_master(trial,4) = std(min_ttc);

            
        else if trial == 6
                
                %Reading in COP data
            raw_COP_x = mat_file.Force(2).COP(2,:);
            raw_COP_y = mat_file.Force(2).COP(1,:);
            offset_x = 310.85594;
            offset_y = 1010.0105;

            %Offset COP
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

            %skip first 10 frames of trial
            cop_x = cop_x(25:end-25,1);
            cop_y = cop_y(25:end-25,1);
           
            check_stance = isstrprop(mat_file.Trajectories.Labeled.Labels{1, 3},'alpha');
            
            if sum(check_stance) == 5
            
                %marker locations
                r2ndmet = [(mean(mat_file.Trajectories.Labeled.Data(1,2,:))), mean(mat_file.Trajectories.Labeled.Data(1,1,:))+60];
                r5thmet = [mean(mat_file.Trajectories.Labeled.Data(2,2,:)), mean(mat_file.Trajectories.Labeled.Data(2,1,:))];
                rheel = [mean(mat_file.Trajectories.Labeled.Data(3,2,:)), mean(mat_file.Trajectories.Labeled.Data(3,1,:))];
                llatheel = [mean(mat_file.Trajectories.Labeled.Data(6,2,:)), mean(mat_file.Trajectories.Labeled.Data(6,1,:))];
                l5thmet = [mean(mat_file.Trajectories.Labeled.Data(5,2,:)), mean(mat_file.Trajectories.Labeled.Data(5,1,:))];
                l2ndmet = [(mean(mat_file.Trajectories.Labeled.Data(4,2,:))), mean(mat_file.Trajectories.Labeled.Data(4,1,:))+60];

                %vector of bounds points
                %6 markers
                bound_pts = [l2ndmet; r2ndmet; r5thmet; rheel; llatheel; l5thmet];
            
            else
               
                %marker locations
                r2ndmet = [(mean(mat_file.Trajectories.Labeled.Data(1,2,:))), mean(mat_file.Trajectories.Labeled.Data(1,1,:))+60];
                r5thmet = [mean(mat_file.Trajectories.Labeled.Data(2,2,:)), mean(mat_file.Trajectories.Labeled.Data(2,1,:))];
                rlatheel = [mean(mat_file.Trajectories.Labeled.Data(3,2,:)), mean(mat_file.Trajectories.Labeled.Data(3,1,:))];
                lheel = [mean(mat_file.Trajectories.Labeled.Data(6,2,:)), mean(mat_file.Trajectories.Labeled.Data(6,1,:))];
                l5thmet = [mean(mat_file.Trajectories.Labeled.Data(5,2,:)), mean(mat_file.Trajectories.Labeled.Data(5,1,:))];
                l2ndmet = [(mean(mat_file.Trajectories.Labeled.Data(4,2,:))), mean(mat_file.Trajectories.Labeled.Data(4,1,:))+60];

                %vector of bounds points
                %6 Markers
                bound_pts = [r2ndmet; r5thmet; rlatheel; lheel; l5thmet; l2ndmet];
            end
                
            %Force plate corner locations
            topL = [12.9277,1303.3];
            bottomL = [7.2091,710.5410];
            bottomR = [597.9800,709.6610];
            topR = [603.9260,1300.6];
            fp_pts = [topR; bottomR; bottomL; topL];

            %time vector
            time = linspace(0.0001,30,length(cop_x)); 
            time = time.';

            x_bos = [bound_pts(:,1); bound_pts(1,1)]; %x coordinates to produce base-of-support outline
            y_bos = [bound_pts(:,2); bound_pts(1,2)]; %y cooridnates to produce base-of-support outline 
            
            %COP vs time
            figure(subject);
            subplot(8,3,16);
            plot(time, cop_x, 'k'); %plot ML CoP
            xlabel('Time (s)');
            ylabel('ML Position (mm)');
            subplot(8,3,17);
            plot(time, cop_y, 'k'); %plot AP CoP
            xlabel('Time (s)');
            ylabel('AP Position (mm)')

            %Calculate Time-to-Contact ===============================================%
            %Boundary labels
            bound_labels = {'FR','R','BR','BL','L','FL'};

            %make sure you adjust sampling rate if you downsample the raw data
            samp_rate = 100; %sampling rate in Hz

            %method for calculating TTC
            method = 2; %1 = Riccio, 2 = Slobounov, 3 = Jerk 

            %compute TtC
            [ttc, bound_ttc, bound_perc] = timetocontact(cop_x, cop_y, 1/samp_rate, bound_pts, method, bound_labels);

            %plot subset of virtual trajectories to check that method is working
            subplot(8,3,18);
            ttc_trajectplot(cop_x, cop_y, 1/samp_rate, x_bos, y_bos, ttc, method);
            set(gca, 'XDir','reverse'); %reverses x axis due to force plate and GCS orientations
            xlim([(fp_pts(3,1) - 32) (fp_pts(1,1) + 32)]); 
            ylim([(fp_pts(3,2) - 10) (fp_pts(1,2) + 10)]);

            %Compute TtC to each boundary
            %Make sure the number of boundary labels (N) is correct in the function ttc_bound_N
            [mean_ttc, med_ttc, min_ttc] = ttc_bound_6(bound_ttc, 50, method, bound_labels);

            ttc_master(trial,1) = mean(mean_ttc);
            ttc_master(trial,2) = std(mean_ttc);
            ttc_master(trial,3) = min(min_ttc);
            ttc_master(trial,4) = std(min_ttc);
            
        else if trial == 7
        
            %Reading in COP data
            raw_COP_x = mat_file.Force(2).COP(2,:);
            raw_COP_y = mat_file.Force(2).COP(1,:);
            offset_x = 310.85594;
            offset_y = 1010.0105;

            %Offset COP
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

            %skip first 10 frames of trial
            cop_x = cop_x(25:end-25,1);
            cop_y = cop_y(25:end-25,1);
           
            check_stance = isstrprop(mat_file.Trajectories.Labeled.Labels{1, 2},'alpha');
            
            if sum(check_stance) == 8
                %marker locations
                l1stmet = [(mean(mat_file.Trajectories.Labeled.Data(3,2,:))), mean(mat_file.Trajectories.Labeled.Data(3,1,:))];
                rlatheel = [mean(mat_file.Trajectories.Labeled.Data(1,2,:)), mean(mat_file.Trajectories.Labeled.Data(1,1,:))];
                rmedheel = [mean(mat_file.Trajectories.Labeled.Data(2,2,:)), mean(mat_file.Trajectories.Labeled.Data(2,1,:))];
                l5thmet = [mean(mat_file.Trajectories.Labeled.Data(4,2,:)), mean(mat_file.Trajectories.Labeled.Data(4,1,:))];

                %vector of bounds points
                %4 markers - left leg forward
                bound_pts = [l1stmet; rlatheel; rmedheel; l5thmet];
            
            else
                %marker locations
                r1stmet = [(mean(mat_file.Trajectories.Labeled.Data(1,2,:))), mean(mat_file.Trajectories.Labeled.Data(1,1,:))];
                r5thmet = [mean(mat_file.Trajectories.Labeled.Data(2,2,:)), mean(mat_file.Trajectories.Labeled.Data(2,1,:))];
                llatheel = [mean(mat_file.Trajectories.Labeled.Data(4,2,:)), mean(mat_file.Trajectories.Labeled.Data(4,1,:))];
                lmedheel = [mean(mat_file.Trajectories.Labeled.Data(3,2,:)), mean(mat_file.Trajectories.Labeled.Data(3,1,:))];

                %vector of bounds points
                %4 markers
                bound_pts = [r5thmet; lmedheel; llatheel; r1stmet];
            end
                
            %Force plate corner locations
            topL = [12.9277,1303.3];
            bottomL = [7.2091,710.5410];
            bottomR = [597.9800,709.6610];
            topR = [603.9260,1300.6];
            fp_pts = [topR; bottomR; bottomL; topL];

            %time vector
            time = linspace(0.0001,30,length(cop_x)); 
            time = time.';

            x_bos = [bound_pts(:,1); bound_pts(1,1)]; %x coordinates to produce base-of-support outline
            y_bos = [bound_pts(:,2); bound_pts(1,2)]; %y cooridnates to produce base-of-support outline 
            
            %COP vs time
            figure(subject);
            subplot(8,3,19);
            plot(time, cop_x, 'k'); %plot ML CoP
            xlabel('Time (s)');
            ylabel('ML Position (mm)');
            subplot(8,3,20);
            plot(time, cop_y, 'k'); %plot AP CoP
            xlabel('Time (s)');
            ylabel('AP Position (mm)')

            %Calculate Time-to-Contact ===============================================%
            %Boundary labels
            bound_labels = {'FR','R','BR','BL','L','FL'};

            %make sure you adjust sampling rate if you downsample the raw data
            samp_rate = 100; %sampling rate in Hz

            %method for calculating TTC
            method = 2; %1 = Riccio, 2 = Slobounov, 3 = Jerk 

            %compute TtC
            [ttc, bound_ttc, bound_perc] = timetocontact(cop_x, cop_y, 1/samp_rate, bound_pts, method, bound_labels);

            %plot subset of virtual trajectories to check that method is working
            subplot(8,3,21);
            ttc_trajectplot(cop_x, cop_y, 1/samp_rate, x_bos, y_bos, ttc, method);
            set(gca, 'XDir','reverse'); %reverses x axis due to force plate and GCS orientations
            xlim([(fp_pts(3,1) - 32) (fp_pts(1,1) + 32)]); 
            ylim([(fp_pts(3,2) - 10) (fp_pts(1,2) + 10)]);

            %Compute TtC to each boundary
            %Make sure the number of boundary labels (N) is correct in the function ttc_bound_N
            [mean_ttc, med_ttc, min_ttc] = ttc_bound_4(bound_ttc, 50, method, bound_labels);

            ttc_master(trial,1) = mean(mean_ttc);
            ttc_master(trial,2) = std(mean_ttc);
            ttc_master(trial,3) = min(min_ttc);
            ttc_master(trial,4) = std(min_ttc);
            
        else 
                
                %Reading in COP data
            raw_COP_x = mat_file.Force(2).COP(2,:);
            raw_COP_y = mat_file.Force(2).COP(1,:);
            offset_x = 310.85594;
            offset_y = 1010.0105;

            %Offset COP
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

            %skip first 10 frames of trial
            cop_x = cop_x(25:end-25,1);
            cop_y = cop_y(25:end-25,1);
            
            check_stance = mat_file.Trajectories.Labeled.Data(3,2,1) - mat_file.Trajectories.Labeled.Data(1,2,1);
            
            if check_stance > 0
                %marker locations
                firstmet = [(mean(mat_file.Trajectories.Labeled.Data(1,2,:))), mean(mat_file.Trajectories.Labeled.Data(1,1,:))];
                secondmet = [(mean(mat_file.Trajectories.Labeled.Data(2,2,:))), mean(mat_file.Trajectories.Labeled.Data(2,1,:))+60];
                fifthmet = [mean(mat_file.Trajectories.Labeled.Data(3,2,:)), mean(mat_file.Trajectories.Labeled.Data(3,1,:))];
                latheel = [mean(mat_file.Trajectories.Labeled.Data(6,2,:)), mean(mat_file.Trajectories.Labeled.Data(6,1,:))];
                heel = [mean(mat_file.Trajectories.Labeled.Data(4,2,:)), mean(mat_file.Trajectories.Labeled.Data(4,1,:))];
                medheel = [mean(mat_file.Trajectories.Labeled.Data(5,2,:)), mean(mat_file.Trajectories.Labeled.Data(5,1,:))];

                %Left Leg bounds_pts
                bound_pts = [firstmet; medheel; heel; latheel; fifthmet; secondmet];

            else
                %marker locations
                firstmet = [(mean(mat_file.Trajectories.Labeled.Data(1,2,:))), mean(mat_file.Trajectories.Labeled.Data(1,1,:))];
                secondmet = [(mean(mat_file.Trajectories.Labeled.Data(2,2,:))), mean(mat_file.Trajectories.Labeled.Data(2,1,:))+60];
                fifthmet = [mean(mat_file.Trajectories.Labeled.Data(3,2,:)), mean(mat_file.Trajectories.Labeled.Data(3,1,:))];
                latheel = [mean(mat_file.Trajectories.Labeled.Data(5,2,:)), mean(mat_file.Trajectories.Labeled.Data(5,1,:))];
                heel = [mean(mat_file.Trajectories.Labeled.Data(4,2,:)), mean(mat_file.Trajectories.Labeled.Data(4,1,:))];
                medheel = [mean(mat_file.Trajectories.Labeled.Data(6,2,:)), mean(mat_file.Trajectories.Labeled.Data(6,1,:))];
                
                %Right Leg bounds_pts
                bound_pts = [fifthmet; latheel; heel; medheel; firstmet; secondmet];
            end
                
            %Force plate corner locations
            topL = [12.9277,1303.3];
            bottomL = [7.2091,710.5410];
            bottomR = [597.9800,709.6610];
            topR = [603.9260,1300.6];
            fp_pts = [topR; bottomR; bottomL; topL];

            %time vector
            time = linspace(0.0001,30,length(cop_x)); 
            time = time.';

            x_bos = [bound_pts(:,1); bound_pts(1,1)]; %x coordinates to produce base-of-support outline
            y_bos = [bound_pts(:,2); bound_pts(1,2)]; %y cooridnates to produce base-of-support outline 
            
            %COP vs time
            figure(subject);
            subplot(8,3,22);
            plot(time, cop_x, 'k'); %plot ML CoP
            xlabel('Time (s)');
            ylabel('ML Position (mm)');
            subplot(8,3,23);
            plot(time, cop_y, 'k'); %plot AP CoP
            xlabel('Time (s)');
            ylabel('AP Position (mm)')

            %Calculate Time-to-Contact ===============================================%
            %Boundary labels
            bound_labels = {'FR','R','BR','BL','L','FL'};

            %make sure you adjust sampling rate if you downsample the raw data
            samp_rate = 100; %sampling rate in Hz

            %method for calculating TTC
            method = 2; %1 = Riccio, 2 = Slobounov, 3 = Jerk 

            %compute TtC
            [ttc, bound_ttc, bound_perc] = timetocontact(cop_x, cop_y, 1/samp_rate, bound_pts, method, bound_labels);

            %plot subset of virtual trajectories to check that method is working
            subplot(8,3,24);
            ttc_trajectplot(cop_x, cop_y, 1/samp_rate, x_bos, y_bos, ttc, method);
            set(gca, 'XDir','reverse'); %reverses x axis due to force plate and GCS orientations
            xlim([(fp_pts(3,1) - 32) (fp_pts(1,1) + 32)]); 
            ylim([(fp_pts(3,2) - 10) (fp_pts(1,2) + 10)]);

            %Compute TtC to each boundary
            %Make sure the number of boundary labels (N) is correct in the function ttc_bound_N
            [mean_ttc, med_ttc, min_ttc] = ttc_bound_6(bound_ttc, 50, method, bound_labels);

            ttc_master(trial,1) = mean(mean_ttc);
            ttc_master(trial,2) = std(mean_ttc);
            ttc_master(trial,3) = min(min_ttc);
            ttc_master(trial,4) = std(min_ttc);
            
            end
            end
            end
            end
            end
            end
            
            
        end
    end
    ttc_master_all = [ttc_master_all,ttc_master];
    
    mean_ttc = (ttc_master + ttc_master)/subject;
   
end


      
        