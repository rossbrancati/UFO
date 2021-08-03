%This function plots each participants average for each condition on one
%plot. End result is four figures with hip, knee, and ankle sagittal plane 
%joint angles (stance and full gait cycle), moments, and powers (one
%figure) per condition).
%
%Updated 8/2/21 by Ross

function UFO_waveform_plotting(base_file_path,group)

    mean_dir = dir([base_file_path,group,'/matlab_exports/Participant_Mean_Waveforms']);
    mean_dir(strncmp({mean_dir.name},'.',1))=[];

    participant_cell_array = cell(0,0);
    participant_cell_array{1,1} = ['post_fatigue_fast'];
    participant_cell_array{1,2} = ['post_fatigue_ss'];
    participant_cell_array{1,3} = ['pre_fatigue_fast'];
    participant_cell_array{1,4} = ['pre_fatigue_ss'];


    for i = 1:length(mean_dir)

        current_folder = mean_dir(i,1);
        current_struct = dir(strcat(current_folder.folder,'/',current_folder.name));
        current_struct(strncmp({current_struct.name},'.',1))=[];
        current_struct(contains({current_struct.name},'DS_Store'))=[];
        
        sum_mat = zeros(101,24);
        
        for p = 1:length(current_struct)

            current_file_path = strcat(current_struct(p).folder,'/',current_struct(p).name);
            current_file = importdata(current_file_path);
            sum_mat = sum_mat + current_file;
            participant_cell_array{p+1,i} = current_file;

        end

    end

    [participant_cell_array_r, participant_cell_array_c] = size(participant_cell_array);
    x = linspace(0,100,101)';

    for cond = 1:4


        for sub_id = 2:participant_cell_array_r

            figure(cond)
            %%HIP%%
            %Hip flexion angle stance
            hold on;
            subplot(3,4,1);
            plot(x,(participant_cell_array{sub_id,cond}(:,3)));
            title({'Hip Flexion Angle','Stance Phase'});
            ylabel('Joint angle (degrees)');
            xlabel('Percent Stance (%)');

            %Hip flexion angle GC
            hold on;
            subplot(3,4,2);
            plot(x,(participant_cell_array{sub_id,cond}(:,9)));
            title({'Hip Flexion Angle','Gait Cycle'});
            ylabel('Joint angle (degrees)');
            xlabel('Percent Gait Cycle (%)');

            %Hip flexion moment
            hold on;
            subplot(3,4,3);
            plot(x,(participant_cell_array{sub_id,cond}(:,16)));
            title({'Hip Joint Moment','Stance Phase'});
            ylabel('Joint Moment (%BW*Height)');
            xlabel('Percent Stance (%)');

            %Hip Joint Power
            hold on;
            subplot(3,4,4);
            plot(x,(participant_cell_array{sub_id,cond}(:,21)));
            title({'Hip Joint Power','Stance Phase'});
            ylabel('Joint Moment (W/kg)');
            xlabel('Percent Stance (%)');

            %%KNEE%%
            %Knee flexion angle stance
            hold on;
            subplot(3,4,5);
            plot(x,(participant_cell_array{sub_id,cond}(:,4)));
            title({'Knee Flexion Angle','Stance Phase'});
            ylabel('Joint angle (degrees)');
            xlabel('Percent Stance (%)');

            %Knee flexion angle GC
            hold on;
            subplot(3,4,6);
            plot(x,(participant_cell_array{sub_id,cond}(:,10)));
            title({'Knee Flexion Angle','Gait Cycle'});
            ylabel('Joint angle (degrees)');
            xlabel('Percent Gait Cycle (%)');

            %Knee flexion moment
            hold on;
            subplot(3,4,7);
            plot(x,(participant_cell_array{sub_id,cond}(:,17)));
            title({'Knee Joint Moment','Stance Phase'});
            ylabel('Joint Moment (%BW*Height)');
            xlabel('Percent Stance (%)');

            %Knee Joint Power
            hold on;
            subplot(3,4,8);
            plot(x,(participant_cell_array{sub_id,cond}(:,22)));
            title({'Knee Joint Power','Stance Phase'});
            ylabel('Joint Moment (W/kg)');
            xlabel('Percent Stance (%)');

            %%ANKLE%%
            %Ankle flexion angle stance
            hold on;
            subplot(3,4,9);
            plot(x,(participant_cell_array{sub_id,cond}(:,7)));
            title({'Ankle Flexion Angle','Stance Phase'});
            ylabel('Joint angle (degrees)');
            xlabel('Percent Stance (%)');

            %Ankle flexion angle GC
            hold on;
            subplot(3,4,10);
            plot(x,(participant_cell_array{sub_id,cond}(:,11)));
            title({'Ankle Flexion Angle','Gait Cycle'});
            ylabel('Joint angle (degrees)');
            xlabel('Percent Gait Cycle (%)');

            %Ankle flexion moment
            hold on;
            subplot(3,4,11);
            plot(x,(participant_cell_array{sub_id,cond}(:,20)));
            title({'Ankle Joint Moment','Stance Phase'});
            ylabel('Joint Moment (%BW*Height)');
            xlabel('Percent Stance (%)');

            %Ankle Joint Power
            hold on;
            subplot(3,4,12);
            plot(x,(participant_cell_array{sub_id,cond}(:,23)));        
            title({'Ankle Joint Power','Stance Phase'});
            ylabel('Joint Moment (W/kg)');
            xlabel('Percent Stance (%)');
            
            sgtitle(participant_cell_array{1,cond}, 'Interpreter', 'none', 'FontSize', 24) 

        end

        labels = {};
        for l = 1:length(current_struct)
            name = fliplr(current_struct(l).name);
            labels{l} = ([fliplr(name(5:10))]);
        end

        legend(labels, 'Interpreter', 'none');

    end
end



