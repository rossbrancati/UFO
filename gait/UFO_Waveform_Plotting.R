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
pre_ss_walk = read.csv('/Users/rossbrancati/Desktop/UFO/Gait/Data/Ensemble_Waveforms/pre_fatigue_ss.csv', header=FALSE)
post_ss_walk = read.csv('/Users/rossbrancati/Desktop/UFO/Gait/Data/Ensemble_Waveforms/post_fatigue_ss.csv', header=FALSE)
pre_fast_walk = read.csv('/Users/rossbrancati/Desktop/UFO/Gait/Data/Ensemble_Waveforms/pre_fatigue_fast.csv', header=FALSE)
post_fast_walk = read.csv('/Users/rossbrancati/Desktop/UFO/Gait/Data/Ensemble_Waveforms/post_fatigue_fast.csv', header=FALSE)


current_data = post_fast_walk


ggplot() + 
  geom_ribbon(data=current_data, aes(x=c(0:100), ymin = (V5-V6), ymax = (V5+V6)), fill = rgb(136,28,28,maxColorValue=255), alpha=0.2) +
  geom_line(data=current_data, aes(x=c(0:100),y=V5), color=rgb(136,28,28,maxColorValue=255)) +
  scale_x_continuous(name="% Stance", expand = c(0,0), limits = c(1,100))+
  ylab ("Angle (Degrees)") + 
  ggtitle("Hip Flexion Angle - Stance") + 
  theme_classic() +
  theme(plot.title = element_text(hjust = 0.5))

ggplot() + 
  geom_ribbon(data=current_data, aes(x=c(0:100), ymin = (V7-V8), ymax = (V7+V8)), fill = rgb(136,28,28,maxColorValue=255), alpha=0.2) +
  geom_line(data=current_data, aes(x=c(0:100),y=V7), color=rgb(136,28,28,maxColorValue=255)) +
  scale_x_continuous(name="% Stance", expand = c(0,0), limits = c(1,100))+
  ylab ("Angle (Degrees)") + 
  ggtitle("Knee Flexion Angle - Stance") + 
  theme_classic() +
  theme(plot.title = element_text(hjust = 0.5))

ggplot() + 
  geom_ribbon(data=current_data, aes(x=c(0:100), ymin = (V13-V14), ymax = (V13+V14)), fill = rgb(136,28,28,maxColorValue=255), alpha=0.2) +
  geom_line(data=current_data, aes(x=c(0:100),y=V13), color=rgb(136,28,28,maxColorValue=255)) +
  scale_x_continuous(name="% Stance", expand = c(0,0), limits = c(1,100))+
  ylab ("Angle (Degrees)") + 
  ggtitle("Ankle Flexion Angle - Stance") + 
  theme_classic() +
  theme(plot.title = element_text(hjust = 0.5))

ggplot() + 
  geom_ribbon(data=current_data, aes(x=c(0:100), ymin = (V17-V18), ymax = (V17+V18)), fill = rgb(136,28,28,maxColorValue=255), alpha=0.2) +
  geom_line(data=current_data, aes(x=c(0:100),y=V17), color=rgb(136,28,28,maxColorValue=255)) +
  scale_x_continuous(name="% Stance", expand = c(0,0), limits = c(1,100))+
  ylab ("Angle (Degrees)") + 
  ggtitle("Hip Flexion Angle - Gait Cycle") + 
  theme_classic() +
  theme(plot.title = element_text(hjust = 0.5))

ggplot() + 
  geom_ribbon(data=current_data, aes(x=c(0:100), ymin = (V19-V20), ymax = (V19+V20)), fill = rgb(136,28,28,maxColorValue=255), alpha=0.2) +
  geom_line(data=current_data, aes(x=c(0:100),y=V19), color=rgb(136,28,28,maxColorValue=255)) +
  scale_x_continuous(name="% Stance", expand = c(0,0), limits = c(1,100))+
  ylab ("Angle (Degrees)") + 
  ggtitle("Knee Flexion Angle - Gait Cycle") + 
  theme_classic() +
  theme(plot.title = element_text(hjust = 0.5))

ggplot() + 
  geom_ribbon(data=current_data, aes(x=c(0:100), ymin = (V21-V22), ymax = (V21+V22)), fill = rgb(136,28,28,maxColorValue=255), alpha=0.2) +
  geom_line(data=current_data, aes(x=c(0:100),y=V21), color=rgb(136,28,28,maxColorValue=255)) +
  scale_x_continuous(name="% Stance", expand = c(0,0), limits = c(1,100))+
  ylab ("Angle (Degrees)") + 
  ggtitle("Ankle Flexion Angle - Gait Cycle") + 
  theme_classic() +
  theme(plot.title = element_text(hjust = 0.5))

ggplot() + 
  geom_ribbon(data=current_data, aes(x=c(0:100), ymin = (V31-V32), ymax = (V31+V32)), fill = rgb(136,28,28,maxColorValue=255), alpha=0.2) +
  geom_line(data=current_data, aes(x=c(0:100),y=V31), color=rgb(136,28,28,maxColorValue=255)) +
  scale_x_continuous(name="% Stance", expand = c(0,0), limits = c(1,100))+
  ylab ("Moment (Nm/kg)") + 
  ggtitle("Hip Flexion Moment") + 
  theme_classic() +
  theme(plot.title = element_text(hjust = 0.5))

ggplot() + 
  geom_ribbon(data=current_data, aes(x=c(0:100), ymin = (V34-V35), ymax = (V34+V35)), fill = rgb(136,28,28,maxColorValue=255), alpha=0.2) +
  geom_line(data=current_data, aes(x=c(0:100),y=V34), color=rgb(136,28,28,maxColorValue=255)) +
  scale_x_continuous(name="% Stance", expand = c(0,0), limits = c(1,100))+
  ylab ("Moment (Nm/kg)") + 
  ggtitle("Knee Flexion Moment") + 
  theme_classic() +
  theme(plot.title = element_text(hjust = 0.5))

ggplot() + 
  geom_ribbon(data=current_data, aes(x=c(0:100), ymin = (V39-V40), ymax = (V39+V40)), fill = rgb(136,28,28,maxColorValue=255), alpha=0.2) +
  geom_line(data=current_data, aes(x=c(0:100),y=V39), color=rgb(136,28,28,maxColorValue=255)) +
  scale_x_continuous(name="% Stance", expand = c(0,0), limits = c(1,100))+
  ylab ("Moment (Nm/kg)") + 
  ggtitle("Ankle Flexion Moment") + 
  theme_classic() +
  theme(plot.title = element_text(hjust = 0.5))

