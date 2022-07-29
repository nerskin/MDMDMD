library(tidyverse)

#locations file is a bit awkward, tidy it up a bit
camera_locations <- read_csv('speed_camera_locations.csv') |>
	janitor::clean_names() |>
	mutate(location = str_remove(location,"\\(")) |>
	mutate(location = str_remove(location,"\\)")) |> 
	separate(location,into=c('lat','long'),sep=',')

write_csv(camera_locations,'camera_locations_tidy.csv')
