# This R script pulls the 90-day baseline for our Kona Low NTL analysis
library(blackmarbler)
library(geodata)
library(sf)

bearer <- get_nasa_token(username = "[insert username]", 
                         password = "[insert password]")

# -- Creating folders on the volume -- #
vol <- "/media/volume/aalfaro-NTL-data"
ntl_dir <- file.path(vol, "ntl_baseline")
h5_dir <- file.path(vol, "ntl_h5_raw")

dir.create(ntl_dir, recursive = TRUE, showWarnings = FALSE)
dir.create(h5_dir,  recursive = TRUE, showWarnings = FALSE)

# -- Region of interest: Hawaii -- #
roi_sf <- gadm(country = "USA", level = 1, path = file.path(vol)) |>
  st_as_sf() |>
  subset(NAME_1 == "Hawaii")

roi_sf

# -- 90-day baseline -- #
# Original baseline dates: May 1-July 29, 2025.
# No satellite imagery for May 7, 2025, and July 5-7, 2025.
# I needed to extend the original baseline date range to reach the 90-day total

dates <- seq.Date(as.Date("2025-05-01"), as.Date("2025-08-03"), by = "day")

bm_raster(roi_sf = roi_sf,
          product_id = "VNP46A2",
          date = dates,
          bearer = bearer,
          variable = "Gap_Filled_DNB_BRDF-Corrected_NTL",
          output_location_type = "file",
          file_dir = ntl_dir,
          h5_dir = h5_dir,
          file_skip_if_exists = TRUE)

# -- Check if data was pulled -- #
files <- list.files(ntl_dir, pattern = "\\.tif$", full.names = TRUE)
length(files) # 90 