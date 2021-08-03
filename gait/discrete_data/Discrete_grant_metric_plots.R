#import the libraries
library("readxl")
library("Hmisc")

#Ankle ROM at self selected speed
ankle_rom_ss <- read_excel("/Users/rossbrancati/Desktop/UFO/Gait/Discrete_data/grant_metrics/ankle_rom_ss.xlsx")

ggplot(ankle_rom_ss, aes(x=group, y=ankle_rom)) +
  geom_dotplot(binaxis='y', stackdir='center', aes(fill = sub_id)) +
  scale_x_discrete(limits=c("pre_ss_young_s", "post_ss_young_s", "pre_ss_young_gc", "post_ss_young_gc"),
                   labels = c("Pre Fatigue\nStance Phase", "Post Fatigue\nStance Phase", 
                              "Pre Fatigue\nGait Cycle", "Post Fatigue\nGait Cycle")) +
  stat_summary(fun.data=mean_sdl, fun.args = list(mult=1), geom="pointrange", color="black") +
  scale_fill_discrete(name = "Participant ID") +
  ylab("Ankle ROM (Degrees)") + 
  xlab("Condition") + 
  ggtitle("Ankle Range of Motion at Self Selected Speed") + 
  theme_classic() +
  theme(plot.title = element_text(hjust = 0.5))
  

#Ankle ROM at fast speed
ankle_rom_fast <- read_excel("/Users/rossbrancati/Desktop/UFO/Gait/Discrete_data/grant_metrics/ankle_rom_fast.xlsx")

ggplot(ankle_rom_fast, aes(x=group, y=ankle_rom)) +
  geom_dotplot(binaxis='y', stackdir='center', aes(fill = sub_id)) +
  scale_x_discrete(limits=c("pre_fast_young_s", "post_fast_young_s", "pre_fast_young_gc", "post_fast_young_gc"),
                   labels = c("Pre Fatigue\nStance Phase", "Post Fatigue\nStance Phase", 
                              "Pre Fatigue\nGait Cycle", "Post Fatigue\nGait Cycle")) +
  stat_summary(fun.data=mean_sdl, fun.args = list(mult=1), geom="pointrange", color="black") +
  scale_fill_discrete(name = "Participant ID") +
  ylab("Ankle ROM (Degrees)") + 
  xlab("Condition") + 
  ggtitle("Ankle Range of Motion at Fast Speed") + 
  theme_classic() +
  theme(plot.title = element_text(hjust = 0.5))

#Hip ROM at self selected speed
hip_rom_ss <- read_excel("/Users/rossbrancati/Desktop/UFO/Gait/Discrete_data/grant_metrics/hip_rom_ss.xlsx")

ggplot(hip_rom_ss, aes(x=group, y=hip_rom)) +
  geom_dotplot(binaxis='y', stackdir='center', aes(fill = sub_id)) +
  scale_x_discrete(limits=c("pre_ss_young_s", "post_ss_young_s", "pre_ss_young_gc", "post_ss_young_gc"),
                   labels = c("Pre Fatigue\nStance Phase", "Post Fatigue\nStance Phase", 
                              "Pre Fatigue\nGait Cycle", "Post Fatigue\nGait Cycle")) +
  stat_summary(fun.data=mean_sdl, fun.args = list(mult=1), geom="pointrange", color="black") +
  scale_fill_discrete(name = "Participant ID") +
  ylab("Hip ROM (Degrees)") + 
  xlab("Condition") + 
  ggtitle("Hip Range of Motion at Self Selected Speed") + 
  theme_classic() +
  theme(plot.title = element_text(hjust = 0.5))


#Hip ROM at fast speed
hip_rom_fast <- read_excel("/Users/rossbrancati/Desktop/UFO/Gait/Discrete_data/grant_metrics/hip_rom_fast.xlsx")

ggplot(hip_rom_fast, aes(x=group, y=hip_rom)) +
  geom_dotplot(binaxis='y', stackdir='center', aes(fill = sub_id)) +
  scale_x_discrete(limits=c("pre_fast_young_s", "post_fast_young_s", "pre_fast_young_gc", "post_fast_young_gc"),
                   labels = c("Pre Fatigue\nStance Phase", "Post Fatigue\nStance Phase", 
                              "Pre Fatigue\nGait Cycle", "Post Fatigue\nGait Cycle")) +
  stat_summary(fun.data=mean_sdl, fun.args = list(mult=1), geom="pointrange", color="black") +
  scale_fill_discrete(name = "Participant ID") +
  ylab("Hip ROM (Degrees)") + 
  xlab("Condition") + 
  ggtitle("Hip Range of Motion at Fast Speed") + 
  theme_classic() +
  theme(plot.title = element_text(hjust = 0.5))

#Peak Ankle Dorsiflexion Moment
peak_adm <- read_excel("/Users/rossbrancati/Desktop/UFO/Gait/Discrete_data/grant_metrics/ankle_dors_mom.xlsx")

ggplot(peak_adm, aes(x=group, y=adm_peak)) +
  geom_dotplot(binaxis='y', stackdir='center', aes(fill = sub_id)) +
  scale_x_discrete(limits=c("pre_ss_young", "post_ss_young", "pre_fast_young", "post_fast_young"),
                   labels = c("Pre Fatigue\nSelf Selected\nSpeed", "Post Fatigue\nSelf Selected\nSpeed", 
                              "Pre Fatigue\nFast Speed", "Post Fatigue\nFast Speed")) +
  stat_summary(fun.data=mean_sdl, fun.args = list(mult=1), geom="pointrange", color="black") +
  scale_fill_discrete(name = "Participant ID") +
  ylab("Ankle Dorsiflexion Moment\n(%BW*Height)") + 
  xlab("Condition") + 
  ggtitle("Peak Ankle Dorsiflexion Moment at Both Gait Speeds") + 
  theme_classic() +
  theme(plot.title = element_text(hjust = 0.5))

#Peak Ankle Dorsiflexion Moment
hip_ext_mom <- read_excel("/Users/rossbrancati/Desktop/UFO/Gait/Discrete_data/grant_metrics/hip_ext_mom.xlsx")

ggplot(hip_ext_mom, aes(x=group, y=hem_peak)) +
  geom_dotplot(binaxis='y', stackdir='center', aes(fill = sub_id)) +
  scale_x_discrete(limits=c("pre_ss_young", "post_ss_young", "pre_fast_young", "post_fast_young"),
                   labels = c("Pre Fatigue\nSelf Selected\nSpeed", "Post Fatigue\nSelf Selected\nSpeed", 
                              "Pre Fatigue\nFast Speed", "Post Fatigue\nFast Speed")) +
  stat_summary(fun.data=mean_sdl, fun.args = list(mult=1), geom="pointrange", color="black") +
  scale_fill_discrete(name = "Participant ID") +
  ylab("Hip Extension Moment\n(%BW*Height)") + 
  xlab("Condition") + 
  ggtitle("Peak Hip Extension Moment at Both Gait Speeds") + 
  theme_classic() +
  theme(plot.title = element_text(hjust = 0.5))