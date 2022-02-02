library(tidyverse)
library(car)
library(ggplot2)
library(gridExtra)

data <- read.csv('results-main.csv')
data

data$app = as.factor(data$app)
data$number_of_participants = as.factor(data$number_of_participants)
data$camera = as.factor(data$camera)
data$microphone = as.factor(data$microphone)
data$background = as.factor(data$background)

check_normality <- function(dataset_to_eval, plot_title) {
  plot(density(dataset_to_eval$joules), main=plot_title, ylab="Density", xlab="Energy consumption [J]")
  qqPlot(dataset_to_eval$joules, xlab="Normal quantiles", ylab="Sample quantiles")
  print(shapiro.test(dataset_to_eval$joules)) # need to print explicitly in a loop
}

par(mfrow=c(1,2))

check_normality(data, "all data")

plot1 <- ggplot(data, aes(x=number_of_participants, y=joules, fill=app)) + geom_violin(trim=FALSE)
plot2 <- ggplot(data, aes(x=camera, y=joules, fill=app)) + geom_violin(trim=FALSE)
plot3 <- ggplot(data, aes(x=microphone, y=joules, fill=app)) + geom_violin(trim=FALSE)
plot4 <- ggplot(data, aes(x=background, y=joules, fill=app)) + geom_violin(trim=FALSE)


grid.arrange(plot1, plot2, plot3, plot4, nrow=2, ncol=2)

#--------------------------


datazoom <- data %>%
  filter(app == "Zoom") 

datameet <- data %>%
  filter(app == "Meet") 

par(mfrow=c(4,1))

check_normality(datazoom, "Zoom")

check_normality(datameet, "Meet")


#--------------------------




datazoomcam <- data %>%
  filter(app == "Zoom") %>%
  filter(camera == "True")

datazoomcamoff <- data %>%
  filter(app == "Zoom") %>%
  filter(camera == "False")

datameetcam <- data %>%
  filter(app == "Meet") %>%
  filter(camera == "True")

datameetcamoff <- data %>%
  filter(app == "Meet") %>%
  filter(camera == "False")

datazoommic <- data %>%
  filter(app == "Zoom") %>%
  filter(microphone == "True")

datazoommicoff <- data %>%
  filter(app == "Zoom") %>%
  filter(microphone == "False")

datameetmic <- data %>%
  filter(app == "Meet") %>%
  filter(microphone == "True")

datameetmicoff <- data %>%
  filter(app == "Meet") %>%
  filter(microphone == "False")

datazoom2 <- data %>%
  filter(app == "Zoom") %>%
  filter(number_of_participants == "2")

datazoom5 <- data %>%
  filter(app == "Zoom") %>%
  filter(number_of_participants == "5")

datameet2 <- data %>%
  filter(app == "Meet") %>%
  filter(number_of_participants == "2")

datameet5 <- data %>%
  filter(app == "Meet") %>%
  filter(number_of_participants == "5")

datazoomback <- data %>%
  filter(app == "Zoom") %>%
  filter(background == "True")

datazoomnoback <- data %>%
  filter(app == "Zoom") %>%
  filter(background == "False")

datameetback <- data %>%
  filter(app == "Meet") %>%
  filter(background == "True")

datameetnoback <- data %>%
  filter(app == "Meet") %>%
  filter(background == "False")


par(mfrow=c(1,2))
check_normality(datazoomback, "Zoom with virtual background")

check_normality <- function(dataset_to_eval, plot_title="") {
  plot(density(dataset_to_eval$joules),main=plot_title,xlab="",ylab="",axes=FALSE)
  qqPlot(dataset_to_eval$joules,xlab="",ylab="")
  print(shapiro.test(dataset_to_eval$joules)) # need to print explicitly in a loop
}
par(mfrow=c(8,4), ann=TRUE, mar = c(1,2,1,1))

check_normality(datazoomcam, "Zoom camera on")
check_normality(datazoomcamoff, "Zoom camera off")
check_normality(datameetcam, "Meet camera on")
check_normality(datameetcamoff, "Meet camera off")

check_normality(datazoommic, "Zoom microphone on")
check_normality(datazoommicoff, "Zoom microphone off")
check_normality(datameetmic, "Meet microphone on")
check_normality(datameetmicoff, "Meet microphone off")

check_normality(datazoom2, "Zoom 2 participants")
check_normality(datazoom5, "Zoom 5 participants")
check_normality(datameet2, "Meet 2 participants")
check_normality(datameet5, "Meet 5 participants")

check_normality(datazoomback, "Zoom background on")
check_normality(datazoomnoback, "Zoom background off")
check_normality(datameetback, "Meet background on")
check_normality(datameetnoback, "Meet background off")

#---------------------------------------
#datacam <- data %>%
#  filter(camera == "True")

#datacamoff <- data %>%
#  filter(camera == "False")

#datamic <- data %>%
#  filter(microphone == "True")

#datamicoff <- data %>%
#  filter(microphone == "False")

#data2 <- data %>%
#  filter(number_of_participants == "2")

#data5 <- data %>%
#  filter(number_of_participants == "5")

#databack <- data %>%
#  filter(background == "True")

#datanoback <- data %>%
#  filter(background == "False")

#check_normality(datacam, "cam")
#check_normality(datacamoff, "no cam")

#check_normality(datamic, "mic")
#check_normality(datamicoff, "no mic")

#check_normality(data2, "2")
#check_normality(data5, "5")

#check_normality(databack, "back")
#check_normality(datanoback, "no back")