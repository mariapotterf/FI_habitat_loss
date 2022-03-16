

# Valuable habitats loss in Finland

# RQ: are we loosing teh most valuable habitats?
# eg. is the loss faster in more valuable stands?
# are more valuable stands also older?   

# Steps - develop over individual scripts


# Aim: evelop the input data for Pihla for following processing 

# Create tile for the forest age: 2015 - make a raster mosaics from tiles
#   download data from LUKE: 
#   manually, from 2015: https://kartta.luke.fi/opendata/valinta-en.html  
# Analyse the disturbance data - Finland from Cornelius:
#   dopwnload from: https://zenodo.org/record/4746129#.YjCu5zGZMuU
# analyse them by the grid of different size? I suggest yes
# Make a script to get the hexagons over FI
#       12 km size
# get map for FI



# --------------------------------------------------
# Create a forest raster for whole Finland:
# --------------------------------------------------

#   read files in zip files - 'walk' in tidyverse
#   create a mosaic
#   resample to 30 m res?
#   export as single raster: try to shhring down the size

library(tidyverse)  # to unzip all files 


library(terra)  # for raster processing



# Read files
setwd('C:/Users/ge45lep/Documents/2022_disturba_Finland/')

# 
in_zip  = paste(getwd(), 'raw/FI_age_2015/2015/', sep = '/')
out_zip = 'C:/Users/ge45lep/Documents/2022_disturba_Finland/raw/age_tif/'

# Read all files in directory
ls_zip <- list.files(in_zip, pattern = ".zip$", recursive = TRUE)

# walk throught all zip files and extract them all in respectives folders
walk(ls_zip, ~ unzip(zipfile = str_c(in_zip, .x), 
                         exdir = str_c(out_zip, .x)))


# Read all new raster files, stored in the subdirectories
ls_tiff <- list.files(out_zip, pattern = ".tif$", recursive = TRUE)  # recursive = True goes into subdirectories

# Read data as rasters
ls_rst <- lapply(ls_tiff, rast)


# Create a raster mosaic of all the rasters:
# merge the tiles: from the LUKE map, the tiles are 3*12:
r1 <- rast(paste(out_zip, 'ika_vmi1x_1216_L3.tif.zip/ika_vmi1x_1216_L3.tif', sep = ''))



r1 <- rast('ika_vmi1x_1216_S4.tif.zip/ika_vmi1x_1216_S4.tif')
