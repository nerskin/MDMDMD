library(tidyverse)
library(arrow)

locations <- read_csv('camera_locations_tidy.csv')
fines <- read_parquet("Traffic_camera_fines_and_offences.parquet")
