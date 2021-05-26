%Plotting
%Individual waveforms will go on one plot
%Means +/- 

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
end

vars = 0;
sub_id = 0;
cond = 0;
x = linspace(0,100,101)';

for cond = 1:4
    
    
    for sub_id = 2:length(participant_cell_array)
        
        figure(cond)
        %%HIP%%
        %Hip flexion angle stance
        hold on;
        subplot(4,4,1);
        plot(x,(participant_cell_array{sub_id,cond}(:,3)));
        title('Flexion Angle - Stance');
        ylabel('Hip','FontWeight','bold');

        %Hip flexion angle GC
        hold on;
        subplot(4,4,2);
        plot(x,(participant_cell_array{sub_id,cond}(:,9)));
        title('Flexion Angle - Gait Cycle');
        
        %Hip flexion moment
        hold on;
        subplot(4,4,3);
        plot(x,(participant_cell_array{sub_id,cond}(:,16)));
        title('Flexion Moment');
        
        %Hip Joint Power
        hold on;
        subplot(4,4,4);
        plot(x,(participant_cell_array{sub_id,cond}(:,21)));
        title('Joint Power');
        
        %%KNEE%%
        %Knee flexion angle stance
        hold on;
        subplot(4,4,5);
        plot(x,(participant_cell_array{sub_id,cond}(:,4)));
        ylabel('Knee','FontWeight','bold');
        
        %Knee flexion angle GC
        hold on;
        subplot(4,4,6);
        plot(x,(participant_cell_array{sub_id,cond}(:,10)));
        
        %Knee flexion moment
        hold on;
        subplot(4,4,7);
        plot(x,(participant_cell_array{sub_id,cond}(:,17)));
        
        %Knee Joint Power
        hold on;
        subplot(4,4,8);
        plot(x,(participant_cell_array{sub_id,cond}(:,22)));
        
        
        %%ANKLE%%
        %Ankle flexion angle stance
        hold on;
        subplot(4,4,9);
        plot(x,(participant_cell_array{sub_id,cond}(:,7)));
        ylabel('Ankle','FontWeight','bold');
        
        %Ankle flexion angle GC
        hold on;
        subplot(4,4,10);
        plot(x,(participant_cell_array{sub_id,cond}(:,11)));
        
        %Ankle flexion moment
        hold on;
        subplot(4,4,11);
        plot(x,(participant_cell_array{sub_id,cond}(:,20)));
        
        %Ankle Joint Power
        hold on;
        subplot(4,4,12);
        plot(x,(participant_cell_array{sub_id,cond}(:,23)));
        
        
        %%PELVIS%%
        %Pelvis Angle Stance (X)
        hold on;
        subplot(4,4,13);
        plot(x,(participant_cell_array{sub_id,cond}(:,12)));
        ylabel('Pelvis','FontWeight','bold');
        
        %Plevis Angle GC (X)
        hold on;
        subplot(4,4,14);
        plot(x,(participant_cell_array{sub_id,cond}(:,13)));        
        
    end
    
    legend('13','25','36','65','70','75','86');

end





