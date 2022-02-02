install.packages("ggplot2")
install.packages("dplyr")
install.packages("effsize")
library(ggplot2)
library(dplyr)
library(effsize)

# Loading data
energy_data <- read.csv("results-main.csv") %>%
  mutate(camera = ifelse(camera, "on", "off")) %>%
  mutate(microphone = ifelse(microphone, "on", "off")) %>%
  mutate(background = ifelse(background, "on", "off"))
meet_data <- energy_data %>% filter(app == "Meet")
zoom_data <- energy_data %>% filter(app == "Zoom")

effect_size <- function(data1, data2) {
  cliff.delta(data2$joules, data1$joules)
}

effect_size(meet_data, zoom_data)

effect_size(filter(meet_data, number_of_participants == "2"), filter(meet_data, number_of_participants == "5"))
effect_size(filter(meet_data, camera == "off"), filter(meet_data, camera == "on"))
effect_size(filter(meet_data, background == "off" & camera == "on"), filter(meet_data, background == "on" & camera == "on"))
effect_size(filter(meet_data, microphone == "off"), filter(meet_data, microphone == "on"))

effect_size(filter(zoom_data, number_of_participants == "2"), filter(zoom_data, number_of_participants == "5"))
effect_size(filter(zoom_data, camera == "off"), filter(zoom_data, camera == "on"))
effect_size(filter(zoom_data, background == "off" & camera == "on"), filter(zoom_data, background == "on" & camera == "on"))
effect_size(filter(zoom_data, microphone == "off"), filter(zoom_data, microphone == "on"))
