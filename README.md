UFO:

This is a repository for all scripts related to the UFO project that we use in the MOBL lab. Run UFO_Participant_Waveform_Means > UFO_Ensemble_Waveforms > WFO_Waveform_Plotting

UFO_Participant_Waveform_Means.m: pulls V3D data from subjects folders, normalizes to 101 data points, averages the condition trials together, and exports to a .csv file for each condition. Each participant ends up with 4 total .csv files (pre_ss, pre_fast, post_ss, post_fast)

UFO_Ensemble_Waveforms.m: takes the files generated from UFO_Participant_Waveform_Means and averages them all together to produces a grouped ensemble average. Also calculated standard deviation. End result is 4 files - pre_ss, pre_fast, post_ss, post_fast

UFO_Waveform_Plotting.m: Plots the sagittal plane waveforms of the participant means. For example, one plot is knee flexion angle with x participant curves on it. Will plot all variables on one figure

UFO_Waveform_Plotting.R: R script that imports the data from UFO_Ensemble_Waveforms and plots the ensemble averages +/- standard deviation
