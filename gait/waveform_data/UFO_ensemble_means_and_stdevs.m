%Function that creates a directory of the condition, loops through the
%files for the condition and calculates averages and standard deviations
%for each condition. This data is imported into R for plotting.
%
%Updated 8/2/21 by Ross



function UFO_ensemble_means_and_stdevs(base_file_path,group)

    %create directory 
    stdev_directory = dir([base_file_path,group,'/matlab_exports/Participant_Mean_Waveforms']);
    stdev_directory(strncmp({stdev_directory.name},'.',1))=[];
    
    %loop through the condition folders in the directory
    for condition = 1:length(stdev_directory)

        %set variable to the current condition folder
        current_directory_name = stdev_directory(condition);
        current_folder = [current_directory_name.folder,'/',current_directory_name.name];

        %create a directory of the current condition
        current_directory = dir(current_folder);
        current_directory(strncmp({current_directory.name},'.',1))=[];
        
        %create an empty cell array
        cell_array = {};

        %loop through the current_directory
        for n = 1:length(current_directory)

            %import the participants file which is the mean of their trials for
            %the particular condition
            file_id = readtable([current_directory(n).folder,'/',current_directory(n).name]);

            %store the data as a matrix in a cell array to access for
            %calculating standard deviation
            cell_array{n,1} = table2array(file_id(:,:));

        end

        %Compute the elementwise mean across all arrays within each cell
        mean_mat = arrayfun(@(i){mean(cat(3,cell_array{:,i}),3)},1:size(cell_array,2));

        %Compute the elementwise standard deviation across all arrayw within
        %each cell
        stdev_mat = arrayfun(@(i){std(cat(3,cell_array{:,i}),[],3)},1:size(cell_array,2));

        %convert mean and standard deviations to tables
        mean_table = array2table(mean_mat{1,1},'VariableNames',{'fp1_grf','fp2_grf','hip_angle_x_s','knee_angle_x_s','knee_angle_y_s','knee_angle_z_s','ankle_angle_x_s','ankle_angle_y_s','hip_angle_x_f','knee_angle_x_f','ankle_angle_x_f','pelvis_angle_x_s','pelvis_angle_x_f','pelvis_angle_y_s','pelvis_angle_z_s','hip_mom_x','knee_mom_x','knee_mom_y','knee_mom_z','ankle_mom_x','hip_power_x','knee_power_x','ankle_power_x','knee_displ'});
        stdev_table = array2table(stdev_mat{1,1},'VariableNames',{'fp1_grf_stdev','fp2_grf_stdev','hip_angle_x_s_stdev','knee_angle_x_s_stdev','knee_angle_y_s_stdev','knee_angle_z_s_stdev','ankle_angle_x_s_stdev','ankle_angle_y_s_stdev','hip_angle_x_f_stdev','knee_angle_x_f_stdev','ankle_angle_x_f_stdev','pelvis_angle_x_s_stdev','pelvis_angle_x_f_stdev','pelvis_angle_y_s_stdev','pelvis_angle_z_s_stdev','hip_mom_x_stdev','knee_mom_x_stdev','knee_mom_y_stdev','knee_mom_z_stdev','ankle_mom_x_stdev','hip_power_x_stdev','knee_power_x_stdev','ankle_power_x_stdev','knee_displ_stdev'});

        %loop through the means and stdevs matrices and concatenate data into a
        %matrix with |mean|stdev|mean2|stdev2|etc
        means_and_stdevs = [];
        for i = 1:24

            means_and_stdevs(:,i*2-1) = mean_mat{1,1}(:,i);
            means_and_stdevs(:,i*2) = stdev_mat{1,1}(:,i);
        end

        %convert matrix to a table
        means_and_stdevs_table = array2table(means_and_stdevs,'VariableNames',{'fp1_grf','fp1_grf_stdev','fp2_grf','fp2_grf_stdev','hip_angle_x_s','hip_angle_x_s_stdev','knee_angle_x_s','knee_angle_x_s_stdev','knee_angle_y_s','knee_angle_y_s_stdev','knee_angle_z_s','knee_angle_z_s_stdev','ankle_angle_x_s','ankle_angle_x_s_stdev','ankle_angle_y_s','ankle_angle_y_s_stdev','hip_angle_x_f','hip_angle_x_f_stdev','knee_angle_x_f','knee_angle_x_f_stdev','ankle_angle_x_f','ankle_angle_x_f_stdev','pelvis_angle_x_s','pelvis_angle_x_s_stdev','pelvis_angle_x_f','pelvis_angle_x_f_stdev','pelvis_angle_y_s','pelvis_angle_y_s_stdev','pelvis_angle_z_s','pelvis_angle_z_s_stdev','hip_mom_x','hip_mom_x_stdev','knee_mom_x','knee_mom_x_stdev','knee_mom_y','knee_mom_y_stdev','knee_mom_z','knee_mom_z_stdev','ankle_mom_x','ankle_mom_x_stdev','hip_power_x','hip_power_x_stdev','knee_power_x','knee_power_x_stdev','ankle_power_x','ankle_power_x_stdev','knee_displ','knee_displ_stdev'});

        %export the data
        writetable(means_and_stdevs_table,[base_file_path,group,'/matlab_exports/means_and_stdevs/',current_directory_name.name,'.csv']);

    end
    
end
