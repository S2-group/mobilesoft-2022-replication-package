install.packages("ggplot2")
install.packages("dplyr")
library(ggplot2)
library(dplyr)

data_path <- "results-pre.csv"

energy_data <- read.csv(data_path) %>%
  mutate(joules_per_minute = joules / duration_in_minutes)

# Energy consumption depending on duration (should be linear)
ggplot(data = energy_data,
       aes(x = duration_in_minutes, y = joules, color = app)) +
  xlim(0, NA) +
  ylim(0, NA) +
  geom_smooth(method = lm , color = "gray", se = FALSE) +
  geom_jitter() +
  labs(x = "Duration [min]",
       y = "Energy consumption [J]",
       color = "App")

# Mean power consumption depending on duration (should be constant)
ggplot(data = energy_data,
       aes(x = duration_in_minutes, y = joules_per_minute, color = app)) +
  xlim(0, NA) +
  ylim(0, NA) +
  geom_smooth(method = lm , color = "gray", se = FALSE) +
  geom_jitter() +
  labs(x = "Duration [min]",
       y = "Mean power consumption [J/min]",
       color = "App")

meet_data <- energy_data %>% filter(app == "Meet")
zoom_data <- energy_data %>% filter(app == "Zoom")

lm(meet_data$joules ~ meet_data$duration_in_minutes)
lm(zoom_data$joules ~ zoom_data$duration_in_minutes)

joules_per_minute <- energy_data$joules/energy_data$duration_in_minutes
mean(joules_per_minute)
sd(joules_per_minute)
