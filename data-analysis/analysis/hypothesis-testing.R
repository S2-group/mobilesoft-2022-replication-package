install.packages("ggplot2")
install.packages("dplyr")
library(ggplot2)
library(dplyr)

# Loading data
energy_data <- read.csv("results-main.csv") %>%
  mutate(camera = ifelse(camera, "on", "off")) %>%
  mutate(microphone = ifelse(microphone, "on", "off")) %>%
  mutate(background = ifelse(background, "on", "off"))
meet_data <- energy_data %>% filter(app == "Meet")
zoom_data <- energy_data %>% filter(app == "Zoom")


test <- function(data1, data2) {
  wilcox.test(data1$joules, data2$joules)
}

test(meet_data, zoom_data)

test(filter(meet_data, number_of_participants == "2"), filter(meet_data, number_of_participants == "5"))
test(filter(meet_data, camera == "off"), filter(meet_data, camera == "on"))
test(filter(meet_data, background == "off" & camera == "on"), filter(meet_data, background == "on" & camera == "on"))
test(filter(meet_data, microphone == "off"), filter(meet_data, microphone == "on"))

test(filter(zoom_data, number_of_participants == "2"), filter(zoom_data, number_of_participants == "5"))
test(filter(zoom_data, camera == "off"), filter(zoom_data, camera == "on"))
test(filter(zoom_data, background == "off" & camera == "on"), filter(zoom_data, background == "on" & camera == "on"))
test(filter(zoom_data, microphone == "off"), filter(zoom_data, microphone == "on"))

# Perform Benjamini-Hochberg correction
p = c(6.905e-11, 1.402e-11, 2.2e-16, 4.97e-05, 0.3577, 3.745e-06, 2.2e-16, 0.04005, 4.518e-06)
p.adjust(p, method = "BH", n=length(p))
