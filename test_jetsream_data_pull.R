library(blackmarbler)
library(geodata)


bearer <- get_nasa_token(username = "ConnorFlynn", 
                         password = "EarthData120")



roi_sf <- gadm(country = "GHA", level=1, path = tempdir())

roi_sf
