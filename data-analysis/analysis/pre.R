install.packages("tidyverse")
install.packages("rjson")

library(tidyverse)
library(rjson)

config <- fromJSON(file="raw/config.json")
config["duration"] <- as.numeric(config["duration"])


as.numeric(config["duration"]) + 1

