%trials in each condition together for each participant. The final output
%is a .csv file for each participant and each condition (4 total per
%participant)
%Updated 4/25/21

clear;
clc;

%Create a directory of the individual trial files
trial_dir = dir('/Users/rossbrancati/Desktop/UFO/Gait/Data/Gait_Processed_Master');

%create a directory for the average trials for each subject. unused?
%mean_dir = dir('/Users/rossbrancati/Desktop/UFO/Gait/Data/Gait_Trial_Means');

%loop for averaging individual trials together
i = 0;

for i = 4:length(trial_dir)
    
    current_folder = trial_dir(i,1);
    current_struct = dir(strcat(current_folder.folder,'/',current_folder.name));
    
    t = 0;
    
    trial_cell_array = cell(6,24);
    
    %initialize count of number of trials for each condition
    count_pre_ss=0;
    count_pre_fast=0;
    count_post_ss=0;
    count_post_fast=0;
    
    %pre-fatigure self-selecteed speed trials
    for t = 2:6
        current_file_path = strcat(current_folder.folder,'/',current_folder.name,'/',current_folder.name,'_walk_000',num2str(t),'.txt');
        
        %check trials for missing data due to bad trial
        if exist(current_file_path)
           current_file = importdata(current_file_path);
           current_file = current_file.data;
           %remove discrete data points from matrix
           current_file(:,[1:6,9]) = [];
           
           %initialize index to loop over 
           c=0;
           
           count_pre_ss = count_pre_ss+1;
           
           for c = 1:24
               
               current_col = current_file(:,c);
               current_col(isnan(current_col)) = [];
               current_col_resamp = resample(current_col, 101, length(current_col));
               trial_cell_array{t,c} = current_col_resamp;
               
           end
        else
            c=0;
           
            for c = 1:24
               
                trial_cell_array{t,c} = zeros(101,1);
               
            end
            
        end
        
    end
    pre_fatigue_ss_mean = zeros(101,24);
        
    cc=0;
    for cc = 1:24
            
        pre_fatigue_ss_mean(:,cc) = (trial_cell_array{2,cc}+trial_cell_array{3,cc}+trial_cell_array{4,cc}+trial_cell_array{5,cc}+trial_cell_array{6,cc})/count_pre_ss;
      
    end
    
    csvwrite(['/Users/rossbrancati/Desktop/UFO/Gait/Data/Participant_Mean_Waveforms/pre_fatigue_ss/pre_fatigue_ss_',current_folder.name,'.csv'],pre_fatigue_ss_mean);
    
    
    %Pre Fatigue Fast
    for t = 7:11
        current_file_path = strcat(current_folder.folder,'/',current_folder.name,'/',current_folder.name,'_walk_000',num2str(t),'.txt');
        
        %check trials for missing data due to bad trial
        if exist(current_file_path)
           current_file = importdata(current_file_path);
           current_file = current_file.data;
           %remove discrete data points from matrix
           current_file(:,[1:6,9]) = [];
           
           %initialize index to loop over 
           c=0;
           
           count_pre_fast = count_pre_fast+1;
           
           for c = 1:24
               
               current_col = current_file(:,c);
               current_col(isnan(current_col)) = [];
               current_col_resamp = resample(current_col, 101, length(current_col));
               trial_cell_array{t,c} = current_col_resamp;
               
           end
        else
            c=0;
           
            for c = 1:24
               
                trial_cell_array{t,c} = zeros(101,1);
               
            end
            
        end
        
    end
    pre_fatigue_fast_mean = zeros(101,24);
        
    cc=0;
    for cc = 1:24
            
        pre_fatigue_fast_mean(:,cc) = (trial_cell_array{7,cc}+trial_cell_array{8,cc}+trial_cell_array{9,cc}+trial_cell_array{10,cc}+trial_cell_array{11,cc})/count_pre_fast;
      
    end
    
    csvwrite(['/Users/rossbrancati/Desktop/UFO/Gait/Data/Participant_Mean_Waveforms/pre_fatigue_fast/pre_fatigue_fast_',current_folder.name,'.csv'],pre_fatigue_fast_mean);
        
    
    %Post Fatigue SS
    for t = 13:17
        current_file_path = strcat(current_folder.folder,'/',current_folder.name,'/',current_folder.name,'_walk_00',num2str(t),'.txt');
        
        %check trials for missing data due to bad trial
        if exist(current_file_path)
           current_file = importdata(current_file_path);
           current_file = current_file.data;
           %remove discrete data points from matrix
           current_file(:,[1:6,9]) = [];
           
           %initialize index to loop over 
           c=0;
           
           count_post_ss = count_post_ss+1;
           
           for c = 1:24
               
               current_col = current_file(:,c);
               current_col(isnan(current_col)) = [];
               current_col_resamp = resample(current_col, 101, length(current_col));
               trial_cell_array{t,c} = current_col_resamp;
               
           end
        else
            c=0;
           
            for c = 1:24
               
                trial_cell_array{t,c} = zeros(101,1);
               
            end
            
        end
        
    end
    post_fatigue_ss_mean = zeros(101,24);
        
    cc=0;
    for cc = 1:24
            
        post_fatigue_ss_mean(:,cc) = (trial_cell_array{13,cc}+trial_cell_array{14,cc}+trial_cell_array{15,cc}+trial_cell_array{16,cc}+trial_cell_array{17,cc})/count_post_ss;
      
    end
    
    csvwrite(['/Users/rossbrancati/Desktop/UFO/Gait/Data/Participant_Mean_Waveforms/post_fatigue_ss/post_fatigue_ss_',current_folder.name,'.csv'],post_fatigue_ss_mean);
        
    
    %Post Fatigue Fast
    for t = 18:22
        current_file_path = strcat(current_folder.folder,'/',current_folder.name,'/',current_folder.name,'_walk_00',num2str(t),'.txt');
        
        %check trials for missing data due to bad trial
        if exist(current_file_path)
           current_file = importdata(current_file_path);
           current_file = current_file.data;
           %remove discrete data points from matrix
           current_file(:,[1:6,9]) = [];
           
           %initialize index to loop over 
           c=0;
           
           count_post_fast = count_post_fast+1;
           
           for c = 1:24
               
               current_col = current_file(:,c);
               current_col(isnan(current_col)) = [];
               current_col_resamp = resample(current_col, 101, length(current_col));
               trial_cell_array{t,c} = current_col_resamp;
               
           end
        else
            c=0;
           
            for c = 1:24
               
                trial_cell_array{t,c} = zeros(101,1);
               
            end
            
        end
        
    end
    post_fatigue_fast_mean = zeros(101,24);
        
    cc=0;
    for cc = 1:24
            
        post_fatigue_fast_mean(:,cc) = (trial_cell_array{18,cc}+trial_cell_array{19,cc}+trial_cell_array{20,cc}+trial_cell_array{21,cc}+trial_cell_array{22,cc})/count_post_fast;
      
    end
    
    csvwrite(['/Users/rossbrancati/Desktop/UFO/Gait/Data/Participant_Mean_Waveforms/post_fatigue_fast/post_fatigue_fast_',current_folder.name,'.csv'],post_fatigue_fast_mean);
        
end
            
        
        
            
            
            
            
