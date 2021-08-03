%Script that calls the functions to:
%
%   1) Calculate mean waveforms of the 5 trials for each condition
%
%   2) Calculate the mean and standard deviation for all participants in a
%   group.
%
%   3) Plot each participants mean waveforms for each group
%
%Updated 8/2/21 by Ross
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%folder structure:
%one folder named waveform_data containing a subfolder for each group (young, older_mobile, older_imapred)
%       - Within each groups folder, there should be a folder titled V3D_exports
%         containing the text files exported from V3D
%
%       - Create a folder titled matlab_exports with two subfolders 
%           1) means_and_stdevs
%           2) Participant_Mean_Waveforms
%
%       - Within the Participant_Mean_Waveforms folder, creater four
%         folders, one for each condition
%           1) pre_fatigue_ss
%           2) pre_fatigue_fast
%           1) post_fatigue_ss
%           2) post_fatigue_fast
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear;
clc;

%change the string of the group for whichever group you are working on
group = 'young';

%edit the base file path depending on where the data is stored
base_file_path = '/Users/rossbrancati/Desktop/UFO/Gait/waveform_data/';

%1) Each participants mean of the 5 trials
UFO_participant_mean_waveforms(base_file_path,group)

%2) Ensemble averages and standard deviations
UFO_ensemble_means_and_stdevs(base_file_path,group)

%Plot individual waveforms
UFO_waveform_plotting(base_file_path,group)
