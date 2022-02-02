install.packages("ggplot2")
install.packages("dplyr")
install.packages("gridExtra")
library(ggplot2)
library(dplyr)
library(gridExtra)

# Loading data
energy_data <- read.csv("results-main.csv") %>%
  mutate(camera = ifelse(camera, "on", "off")) %>%
  mutate(microphone = ifelse(microphone, "on", "off")) %>%
  mutate(background = ifelse(background, "on", "off"))
energy_data_camera_on <- filter(energy_data, camera == "on")
meet_data <- energy_data %>% filter(app == "Meet")
zoom_data <- energy_data %>% filter(app == "Zoom")

# Summaries
summary(meet_data$joules)
summary(zoom_data$joules)
summary(energy_data$joules)

# Meet summaries
summary(filter(meet_data, number_of_participants == 2)$joules)
summary(filter(meet_data, number_of_participants == 5)$joules)
summary(filter(meet_data, camera == "off")$joules)
summary(filter(meet_data, camera == "on")$joules)
summary(filter(meet_data, background == "off" & camera == "on")$joules)
summary(filter(meet_data, background == "on" & camera == "on")$joules)
summary(filter(meet_data, microphone == "off")$joules)
summary(filter(meet_data, microphone == "on")$joules)
summary(meet_data$joules)


# Zoom summaries
summary(filter(zoom_data, number_of_participants == 2)$joules)
summary(filter(zoom_data, number_of_participants == 5)$joules)
summary(filter(zoom_data, camera == "off")$joules)
summary(filter(zoom_data, camera == "on")$joules)
summary(filter(zoom_data, background == "off" & camera == "on")$joules)
summary(filter(zoom_data, background == "on" & camera == "on")$joules)
summary(filter(zoom_data, microphone == "off")$joules)
summary(filter(zoom_data, microphone == "on")$joules)
summary(zoom_data$joules)

# Relative changes when changing one factor
print_mean_increase <- function(base_set, actual_set) {
  sprintf("%.1f%%", 100 * ((mean(actual_set$joules)/mean(base_set$joules))-1))
}

# Meet: Relative changes
print_mean_increase(filter(meet_data, number_of_participants == "2"), filter(meet_data, number_of_participants == "5"))
print_mean_increase(filter(meet_data, camera == "off"), filter(meet_data, camera == "on"))
print_mean_increase(filter(meet_data, background == "off" & camera == "on"), filter(meet_data, background == "on" & camera == "on"))
print_mean_increase(filter(meet_data, microphone == "off"), filter(meet_data, microphone == "on"))

# Zoom: Relative changes
print_mean_increase(filter(zoom_data, number_of_participants == "2"), filter(zoom_data, number_of_participants == "5"))
print_mean_increase(filter(zoom_data, camera == "off"), filter(zoom_data, camera == "on"))
print_mean_increase(filter(zoom_data, background == "off" & camera == "on"), filter(zoom_data, background == "on" & camera == "on"))
print_mean_increase(filter(zoom_data, microphone == "off"), filter(zoom_data, microphone == "on"))

# Boxplot for the different apps
ggplot(data = energy_data, aes(x = as.factor(app), y = joules)) +
  ylim(0, NA) +
  xlab("App") +
  ylab("Energy consumption [J]") +
  geom_violin() + 
  geom_boxplot(width=.1, alpha=.5, position=position_dodge(.9)) +
  stat_summary(fun=mean, geom="point", shape="diamond", size=3, color="black")

# Scatterplot for the different apps, color-/shape-coded with camera and mic
ggplot(data = energy_data, aes(x = as.factor(app), y = joules, color = camera, shape = microphone)) +
  ylim(0, NA) +
  xlab("App") +
  ylab("Energy consumption [J]") +
  geom_jitter()

# Meet histogram
meet_histo <- ggplot() +
  geom_histogram(data = meet_data, aes(x = joules), binwidth = 20) +
  xlim(0, NA) +
  xlab("Energy consumption [J]") + 
  ylab("Count") +
  ggtitle("Meet")

# Zoom histogram
zoom_histo <- ggplot() +
  geom_histogram(data = zoom_data, aes(x = joules), binwidth = 20) +
  xlim(0, NA) +
  xlab("Energy consumption [J]") + 
  ylab("Count") +
  ggtitle("Zoom")
grid.arrange(meet_histo, zoom_histo, nrow=1, ncol=2)

# Violin plot: Camera (for the different apps)
ggplot(data = energy_data, aes(x = as.factor(app), y = joules, fill = camera)) +
  ylim(0, NA) +
  xlab("App") +
  ylab("Energy consumption [J]") +
  labs(fill = "Camera") +
  geom_violin() + 
  geom_boxplot(width=.15, alpha=.5, position=position_dodge(.9)) +
  stat_summary(fun=mean, geom="point", shape="diamond", size=3, color="black", position=position_dodge(.9))

# Violin plots: Camera (for the different apps), zoomed in
viobox_camera_off <- ggplot(data = filter(energy_data, camera == "off"), aes(x = as.factor(app), y = joules)) +
  xlab("App") +
  ylab("Energy consumption [J]") +
  geom_violin() + 
  geom_boxplot(width=.15, alpha=.5, position=position_dodge(.9)) +
  stat_summary(fun=mean, geom="point", shape="diamond", size=3, color="black", position=position_dodge(.9)) +
  ggtitle("Camera off")
viobox_camera_on <- ggplot(data = filter(energy_data, camera == "on"), aes(x = as.factor(app), y = joules)) +
  xlab("App") +
  ylab("Energy consumption [J]") +
  ylim(min(filter(energy_data, camera == "on", joules > 300)$joules), NA) + # Filter out outliers
  geom_violin() + 
  geom_boxplot(width=.15, alpha=.5, position=position_dodge(.9)) +
  stat_summary(fun=mean, geom="point", shape="diamond", size=3, color="black", position=position_dodge(.9)) +
  ggtitle("Camera on")
grid.arrange(viobox_camera_off, viobox_camera_on, nrow=1, ncol=2)

# Violin plot: Background (for the different apps)
ggplot(data = energy_data_camera_on, aes(x = as.factor(app), y = joules, fill = background)) +
  ylim(0, NA) +
  xlab("App") +
  ylab("Energy consumption [J]") +
  labs(fill = "Virtual\nbackground") +
  geom_violin() + 
  geom_boxplot(width=.15, alpha=.5, position=position_dodge(.9)) +
  stat_summary(fun=mean, geom="point", shape="diamond", size=3, color="black", position=position_dodge(.9))

# Violin plot: Background (for the different apps), zoomed in
ggplot(data = energy_data_camera_on, aes(x = as.factor(app), y = joules, fill = background)) +
  ylim(0, NA) +
  xlab("App") +
  ylab("Energy consumption [J]") +
  ylim(min(filter(energy_data, camera == "on", joules > 300)$joules), NA) + # Filter out outliers
  labs(fill = "Virtual\nbackground") +
  geom_violin() + 
  geom_boxplot(width=.15, alpha=.5, position=position_dodge(.9)) +
  stat_summary(fun=mean, geom="point", shape="diamond", size=3, color="black", position=position_dodge(.9))

# Violin plot: Microphone (for the different apps)
ggplot(data = energy_data, aes(x = as.factor(app), y = joules, fill = microphone)) +
  ylim(0, NA) +
  xlab("App") +
  ylab("Energy consumption [J]") +
  labs(fill = "Microphone") +
  geom_violin() + 
  geom_boxplot(width=.15, alpha=.5, position=position_dodge(.9)) +
  stat_summary(fun=mean, geom="point", shape="diamond", size=3, color="black", position=position_dodge(.9))


# Violin plot: Number of participants (for the different apps)
ggplot(data = energy_data, aes(x = as.factor(app), y = joules, fill = as.factor(number_of_participants))) +
  ylim(0, NA) +
  xlab("App") +
  ylab("Energy consumption [J]") +
  labs(fill = "Num. of\nparticip.") +
  geom_violin() +
  geom_boxplot(width=.15, alpha=.5, position=position_dodge(.9)) +
  stat_summary(fun=mean, geom="point", shape="diamond", size=3, color="black", position=position_dodge(.9))


#mean(filter(energy_data, camera=="on")$joules)/mean(filter(energy_data, camera=="off")$joules)

meet_camoff <- filter(meet_data, camera == "off")
ggplot(data = meet_camoff, aes(x = as.factor(number_of_participants), y = joules)) +
  ylim(0, NA) +
  xlab("Number of participants") +
  ylab("Energy consumption [J]") +
  labs(fill = "App") +
  geom_boxplot()


barplot(energy_data$joules)

