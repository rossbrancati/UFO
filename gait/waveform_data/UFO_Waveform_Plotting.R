#Plotting script to plot individual participant waveforms and group means +/- sd
#Updated: 4/25/21


##A sad attempt at plotting multiple waveforms on a plot from Sunday 4/25/21
#Pre-Fatigue SS
setwd("/Users/rossbrancati/Desktop/UFO/Gait/Data/Participant_Mean_Waveforms/pre_fatigue_ss")
file_list <- list.files(path = "/Users/rossbrancati/Desktop/UFO/Gait/Data/Participant_Mean_Waveforms/pre_fatigue_ss")

pre_ss_all <- data.frame()

for (i in 1:length(file_list)){
    temp_file <- read.csv(file_list[i], header = FALSE)
    pre_ss_all <- rbind(pre_ss_all, temp_file)
}

ggplot(data=pre_ss_all) + 
  geom_line(aes(x=c(0:706),y=V4))

##Plotting Mean +/- SD 
pre_ss_walk = read.csv('/Users/rossbrancati/Desktop/UFO/Gait/waveform_data/young/matlab_exports/means_and_stdevs/pre_fatigue_ss.csv')
post_ss_walk = read.csv('/Users/rossbrancati/Desktop/UFO/Gait/waveform_data/young/matlab_exports/means_and_stdevs/post_fatigue_ss.csv')
pre_fast_walk = read.csv('/Users/rossbrancati/Desktop/UFO/Gait/waveform_data/young/matlab_exports/means_and_stdevs/pre_fatigue_fast.csv')
post_fast_walk = read.csv('/Users/rossbrancati/Desktop/UFO/Gait/waveform_data/young/matlab_exports/means_and_stdevs/post_fatigue_fast.csv')

#Assigning variables to data
current_pre_speed = pre_fast_walk
current_post_speed = post_fast_walk

#import libraries
library("ggplot2")

##################
###Joint Angles###
######Stance######
##################
ggplot() + 
  geom_ribbon(data=current_pre_speed, aes(x=c(0:100), ymin = (hip_angle_x_s-hip_angle_x_s_stdev), ymax = (hip_angle_x_s+hip_angle_x_s_stdev)), fill = rgb(136,28,28,maxColorValue=255), alpha=0.2) +
  geom_line(data=current_pre_speed, aes(x=c(0:100),y=hip_angle_x_s), color=rgb(136,28,28,maxColorValue=255)) +
  geom_ribbon(data=current_post_speed, aes(x=c(0:100), ymin = (hip_angle_x_s-hip_angle_x_s_stdev), ymax = (hip_angle_x_s+hip_angle_x_s_stdev)), fill = "black", alpha=0.2) +
  geom_line(data=current_post_speed, aes(x=c(0:100),y=hip_angle_x_s), color="black") +
  scale_x_continuous(name="Percent Stance (%)", expand = c(0,0), limits = c(1,100))+
  ylab ("Angle (Degrees)") + 
  ggtitle("Hip Flexion Angle - Stance") + 
  theme_classic() +
  theme(plot.title = element_text(hjust = 0.5, face="bold", size=20), axis.title = element_text(size = 20),
        axis.text.y = element_text(size = 16), axis.text.x = element_text(size = 16), plot.margin = margin(10, 20, 10, 10)) +
  geom_hline(yintercept=0) 
  
ggplot() + 
  geom_ribbon(data=current_pre_speed, aes(x=c(0:100), ymin = (knee_angle_x_s-knee_angle_x_s_stdev), ymax = (knee_angle_x_s+knee_angle_x_s_stdev)), fill = rgb(136,28,28,maxColorValue=255), alpha=0.2) +
  geom_line(data=current_pre_speed, aes(x=c(0:100),y=knee_angle_x_s), color=rgb(136,28,28,maxColorValue=255)) +
  geom_ribbon(data=current_post_speed, aes(x=c(0:100), ymin = (knee_angle_x_s-knee_angle_x_s_stdev), ymax = (knee_angle_x_s+knee_angle_x_s_stdev)), fill = "black", alpha=0.2) +
  geom_line(data=current_post_speed, aes(x=c(0:100),y=knee_angle_x_s), color="black") +
  scale_x_continuous(name="Percent Stance (%)", expand = c(0,0), limits = c(1,100))+
  ylab ("Angle (Degrees)") + 
  ggtitle("Knee Flexion Angle - Stance") + 
  theme_classic() +
  theme(plot.title = element_text(hjust = 0.5, face="bold", size=20), axis.title = element_text(size = 20),
        axis.text.y = element_text(size = 16), axis.text.x = element_text(size = 16), plot.margin = margin(10, 20, 10, 10)) +
  geom_hline(yintercept=0)

ggplot() + 
  geom_ribbon(data=current_pre_speed, aes(x=c(0:100), ymin = (ankle_angle_x_s-ankle_angle_x_s_stdev), ymax = (ankle_angle_x_s+knee_angle_x_s_stdev)), fill = rgb(136,28,28,maxColorValue=255), alpha=0.2) +
  geom_line(data=current_pre_speed, aes(x=c(0:100),y=ankle_angle_x_s), color=rgb(136,28,28,maxColorValue=255)) +
  geom_ribbon(data=current_post_speed, aes(x=c(0:100), ymin = (ankle_angle_x_s-ankle_angle_x_s_stdev), ymax = (ankle_angle_x_s+knee_angle_x_s_stdev)), fill = "black", alpha=0.2) +
  geom_line(data=current_post_speed, aes(x=c(0:100),y=ankle_angle_x_s), color="black") +
  scale_x_continuous(name="Percent Stance (%)", expand = c(0,0), limits = c(1,100))+
  ylab ("Angle (Degrees)") + 
  ggtitle("Ankle Flexion Angle - Stance") + 
  theme_classic() +
  theme(plot.title = element_text(hjust = 0.5, face="bold", size=20), axis.title = element_text(size = 20),
        axis.text.y = element_text(size = 16), axis.text.x = element_text(size = 16), plot.margin = margin(10, 20, 10, 10)) +
  geom_hline(yintercept=0) + 
  annotate("text", x = 11, y = 20, label = "Dorsiflexion (+)") +
  annotate("text", x = 11, y = -15, label = "Plantarflexion (-)")


##################
###Joint Angles###
###Gait Cycle#####
##################
ggplot() + 
  geom_ribbon(data=current_pre_speed, aes(x=c(0:100), ymin = (hip_angle_x_f-hip_angle_x_f_stdev), ymax = (hip_angle_x_f+hip_angle_x_f_stdev)), fill = rgb(136,28,28,maxColorValue=255), alpha=0.2) +
  geom_line(data=current_pre_speed, aes(x=c(0:100),y=hip_angle_x_f), color=rgb(136,28,28,maxColorValue=255)) +
  geom_ribbon(data=current_post_speed, aes(x=c(0:100), ymin = (hip_angle_x_f-hip_angle_x_f_stdev), ymax = (hip_angle_x_f+hip_angle_x_f_stdev)), fill = "black", alpha=0.2) +
  geom_line(data=current_post_speed, aes(x=c(0:100),y=hip_angle_x_f), color="black") +
  scale_x_continuous(name="Percent Gait Cycle (%)", expand = c(0,0), limits = c(1,100))+
  ylab ("Angle (Degrees)") + 
  ggtitle("Hip Flexion Angle - Gait Cycle") + 
  theme_classic() +
  theme(plot.title = element_text(hjust = 0.5, face="bold", size=20), axis.title = element_text(size = 20),
        axis.text.y = element_text(size = 16), axis.text.x = element_text(size = 16), plot.margin = margin(10, 20, 10, 10)) +
  geom_hline(yintercept=0)

ggplot() + 
  geom_ribbon(data=current_pre_speed, aes(x=c(0:100), ymin = (knee_angle_x_f-knee_angle_x_f_stdev), ymax = (knee_angle_x_f+knee_angle_x_f_stdev)), fill = rgb(136,28,28,maxColorValue=255), alpha=0.2) +
  geom_line(data=current_pre_speed, aes(x=c(0:100),y=knee_angle_x_f), color=rgb(136,28,28,maxColorValue=255)) +
  geom_ribbon(data=current_post_speed, aes(x=c(0:100), ymin = (knee_angle_x_f-knee_angle_x_f_stdev), ymax = (knee_angle_x_f+knee_angle_x_f_stdev)), fill = "black", alpha=0.2) +
  geom_line(data=current_post_speed, aes(x=c(0:100),y=knee_angle_x_f), color="black") +
  scale_x_continuous(name="Percent Gait Cycle (%)", expand = c(0,0), limits = c(1,100))+
  ylab ("Angle (Degrees)") + 
  ggtitle("Knee Flexion Angle - Gait Cycle") + 
  theme_classic() +
  theme(plot.title = element_text(hjust = 0.5, face="bold", size=20), axis.title = element_text(size = 20),
        axis.text.y = element_text(size = 16), axis.text.x = element_text(size = 16), plot.margin = margin(10, 20, 10, 10)) +
  geom_hline(yintercept=0)

ggplot() + 
  geom_ribbon(data=current_pre_speed, aes(x=c(0:100), ymin = (ankle_angle_x_f-ankle_angle_x_f_stdev), ymax = (ankle_angle_x_f+knee_angle_x_f_stdev)), fill = rgb(136,28,28,maxColorValue=255), alpha=0.2) +
  geom_line(data=current_pre_speed, aes(x=c(0:100),y=ankle_angle_x_f), color=rgb(136,28,28,maxColorValue=255)) +
  geom_ribbon(data=current_post_speed, aes(x=c(0:100), ymin = (ankle_angle_x_f-ankle_angle_x_f_stdev), ymax = (ankle_angle_x_f+knee_angle_x_f_stdev)), fill = "black", alpha=0.2) +
  geom_line(data=current_post_speed, aes(x=c(0:100),y=ankle_angle_x_f), color="black") +
  scale_x_continuous(name="Percent Gait Cycle (%)", expand = c(0,0), limits = c(1,100))+
  ylab ("Angle (Degrees)") + 
  ggtitle("Ankle Flexion Angle - Gait Cycle") + 
  theme_classic() +
  theme(plot.title = element_text(hjust = 0.5, face="bold", size=20), axis.title = element_text(size = 20),
        axis.text.y = element_text(size = 16), axis.text.x = element_text(size = 16), plot.margin = margin(10, 20, 10, 10)) +
  geom_hline(yintercept=0) + 
  annotate("text", x = 11, y = 20, label = "Dorsiflexion (+)") +
  annotate("text", x = 11, y = -15, label = "Plantarflexion (-)")

###################
###Joint Moments###
###################
ggplot() + 
  geom_ribbon(data=current_pre_speed, aes(x=c(0:100), ymin = (hip_mom_x-hip_mom_x_stdev), ymax = (hip_mom_x+hip_mom_x_stdev)), fill = rgb(136,28,28,maxColorValue=255), alpha=0.2) +
  geom_line(data=current_pre_speed, aes(x=c(0:100),y=hip_mom_x), color=rgb(136,28,28,maxColorValue=255)) +
  geom_ribbon(data=current_post_speed, aes(x=c(0:100), ymin = (hip_mom_x-hip_mom_x_stdev), ymax = (hip_mom_x+hip_mom_x_stdev)), fill = "black", alpha=0.2) +
  geom_line(data=current_post_speed, aes(x=c(0:100),y=hip_mom_x), color="black") +
  scale_x_continuous(name="Percent Stance (%)", expand = c(0,0), limits = c(1,100))+
  ylab ("Moment (%BW*Height)\nEXT(-)/FLX(+)") + 
  ggtitle("Hip Flexion/Extension Moment") + 
  theme_classic() +
  theme(plot.title = element_text(hjust = 0.5, face="bold", size=20), axis.title = element_text(size = 12),
        axis.text.y = element_text(size = 16), axis.text.x = element_text(size = 16), plot.margin = margin(10, 20, 10, 10)) +
  geom_hline(yintercept=0)

ggplot() + 
  geom_ribbon(data=current_pre_speed, aes(x=c(0:100), ymin = (knee_mom_x-knee_mom_x_stdev), ymax = (knee_mom_x+knee_mom_x_stdev)), fill = rgb(136,28,28,maxColorValue=255), alpha=0.2) +
  geom_line(data=current_pre_speed, aes(x=c(0:100),y=knee_mom_x), color=rgb(136,28,28,maxColorValue=255)) +
  geom_ribbon(data=current_post_speed, aes(x=c(0:100), ymin = (knee_mom_x-knee_mom_x_stdev), ymax = (knee_mom_x+knee_mom_x_stdev)), fill = "black", alpha=0.2) +
  geom_line(data=current_post_speed, aes(x=c(0:100),y=knee_mom_x), color="black") +
  scale_x_continuous(name="Percent Stance (%)", expand = c(0,0), limits = c(1,100))+
  ylab ("Moment (%BW*Height)\nFLX(-)/EXT(+)") + 
  ggtitle("Knee Flexion/Extension Moment") + 
  theme_classic() +
  theme(plot.title = element_text(hjust = 0.5, face="bold", size=20), axis.title = element_text(size = 12),
        axis.text.y = element_text(size = 16), axis.text.x = element_text(size = 16), plot.margin = margin(10, 20, 10, 10)) +
  geom_hline(yintercept=0)

ggplot() + 
  geom_ribbon(data=current_pre_speed, aes(x=c(0:100), ymin = (ankle_mom_x-ankle_mom_x_stdev), ymax = (ankle_mom_x+ankle_mom_x_stdev)), fill = rgb(136,28,28,maxColorValue=255), alpha=0.2) +
  geom_line(data=current_pre_speed, aes(x=c(0:100),y=ankle_mom_x), color=rgb(136,28,28,maxColorValue=255)) +
  geom_ribbon(data=current_post_speed, aes(x=c(0:100), ymin = (ankle_mom_x-ankle_mom_x_stdev), ymax = (ankle_mom_x+ankle_mom_x_stdev)), fill = "black", alpha=0.2) +
  geom_line(data=current_post_speed, aes(x=c(0:100),y=ankle_mom_x), color="black") +
  scale_x_continuous(name="Percent Stance (%)", expand = c(0,0), limits = c(1,100))+
  ylab ("Moment (%BW*Height)\nDF(-)/PF(+)") + 
  ggtitle("Ankle Plantarflexion/Dorsiflexion Moment") + 
  theme_classic() +
  theme(plot.title = element_text(hjust = 0.5, face="bold", size=16), axis.title = element_text(size = 12),
        axis.text.y = element_text(size = 16), axis.text.x = element_text(size = 16), plot.margin = margin(10, 20, 10, 10)) +
  geom_hline(yintercept=0)
