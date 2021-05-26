%This script averages all participants waveforms for each condition and
%calculates standard deviation
%Export file variable order: |mean1|std1|mean2|std2|...|mean24|std24|
%Updated: 4/25/21

clear;
clc;

mean_dir = dir('/Users/rossbrancati/Desktop/UFO/Gait/Data/Participant_Mean_Waveforms');

i = 0;

participant_cell_array = cell(0,0);
participant_cell_array{1,1} = ['post_fatigue_fast'];
participant_cell_array{1,2} = ['post_fatigue_ss'];
participant_cell_array{1,3} = ['pre_fatigue_fast'];
participant_cell_array{1,4} = ['pre_fatigue_ss'];


for i = 4:length(mean_dir)
    
    current_folder = mean_dir(i,1);
    current_struct = dir(strcat(current_folder.folder,'/',current_folder.name));
    
    p = 0;
    sum_mat = zeros(101,24);
    
    for p = 3:length(current_struct)
        
        current_file_path = strcat(current_struct(p).folder,'/',current_struct(p).name);
        current_file = importdata(current_file_path);
        sum_mat = sum_mat + current_file;
        participant_cell_array{p-1,i-3} = current_file;
        
    end
        
    ensemble_avg = sum_mat ./ length(mean_dir);
    
    ii=0;
    ensemble_avg_std = zeros(101,48);
    
    for ii=1:24
        ensemble_avg_std(:,(ii*2-1)) = ensemble_avg(:,ii);
    end

    r=0;
    c = 0;
    
    
    for c = 1:24

        for r = 1:101

            %loop over trials
            t = 0;
            for t = 2:length(participant_cell_array)

                std_vect(t-1) = [participant_cell_array{t,i-3}(r,c)];

            end

            current_std = std(std_vect);
            ensemble_avg_std(r,(c*2)) = current_std;

        end
    end
    
    csvwrite(['/Users/rossbrancati/Desktop/UFO/Gait/Data/Ensemble_Waveforms/',mean_dir(i).name,'.csv'],ensemble_avg_std);
    
end



